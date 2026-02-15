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
    
    @State private var selectedCategory: MovieCategory = .nowPlaying
    
    @State private var title: String = "\(MovieCategory.nowPlaying.rawValue) Movies"
    
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
                    if isLoadingNextPage {
                        ProgressView().padding(.vertical, 16)
                    }
                }
                .padding()
            }
            .navigationTitle(self.title)
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(MovieCategory.allCases) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                    } label: {
                        Label("Category", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .task {
            await loadNextPageIfNeeded(forceFirstPage: true)
        }
        .onChange(of: selectedCategory) { _, _ in
            // reset paging state + reload first page
            movies = []
            currentPage = 0
            totalPages = 1
            Task { await loadNextPageIfNeeded(forceFirstPage: true) }
            self.title = "\(selectedCategory.rawValue) Movies"
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
            let response = try await fetchNowPlaying(category: self.selectedCategory, page: nextPage)
            
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

