//
//  ContentView.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import SwiftUI


struct ContentView: View {
    
    @State private var movies: [Movie] = []
    @State private var errorText: String?
    
    @State private var currentPage = 0
    @State private var totalPages = 1
    @State private var isLoadingNextPage = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if let errorText {
                        Text(errorText).foregroundStyle(.red)
                    }
                    
                    LazyVGrid(columns: self.columns, spacing: 10) {
                        ForEach(movies, id: \.id) { movie in
                            NavigationLink(value: movie) {
                                PosterCell(url: movie.posterURL, title: movie.title)
                                    .onAppear {
                                        if movie.id == movies.last?.id {
                                            Task { await loadNextPageIfNeeded() }
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Movies")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
        .task {
            await loadNextPageIfNeeded(forceFirstPage: true)
        }
        if isLoadingNextPage {
            ProgressView().padding(.vertical, 16)
        }
    }
}


extension ContentView {
    private func loadNextPageIfNeeded(forceFirstPage: Bool = false) async {
        if self.isLoadingNextPage { return }
        if !forceFirstPage, self.currentPage >= self.totalPages { return }
        
        self.isLoadingNextPage = true
        defer { self.isLoadingNextPage = false }
        
        do {
            let nextPage = forceFirstPage ? 1 : (self.currentPage + 1)
            let response = try await fetchNowPlaying(page: nextPage)
            
            self.currentPage = response.page
            self.totalPages = response.totalPages
            
            if nextPage == 1 {
                self.movies = response.results
            } else {
                // append next page
                self.movies.append(contentsOf: response.results)
            }
        } catch {
            self.errorText = error.localizedDescription
        }
    }
}

