//
//  ContentView.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import SwiftUI

enum TopTab: String, CaseIterable, Identifiable {
    case movies = "Movies"
    case favorites = "Favorites"
    var id: String { rawValue }
}

struct ContentView: View {
    @State var remoteMovies: [RemoteMovie] = []
    @State var localMovies: [LocalMovie] = []
    
    @State private var errorText: String?
    
    @State private var currentPage = 0
    @State private var totalPages = 1
    @State private var isLoadingNextPage = false
    
    @State private var selectedCategory: MovieCategory = .nowPlaying
    @State private var selectedTab: TopTab = .movies
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    private var displayedTitle: String {
        "\(self.selectedTab == .movies ? selectedCategory.rawValue : "Favorite") Movies"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Picker("", selection: $selectedTab) {
                        ForEach(TopTab.allCases) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .onChange(of: selectedTab) { _, newTab in
                        if newTab == .favorites {
                            self.localMovies = MovieRepository().fetchFavorites()
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if let errorText {
                        Text(errorText).foregroundStyle(.red)
                    }
                    
                    LazyVGrid(columns: self.columns, spacing: 10) {
                        switch self.selectedTab {
                        case .movies:
                            RemoteMovieGrid(movies: self.remoteMovies) {
                                Task { await loadNextPageIfNeeded() }
                            }
                        case .favorites:
                            LocalMovieGrid(movies: self.localMovies)
                        }
                    }
                    if isLoadingNextPage {
                        ProgressView().padding(.vertical, 16)
                    }
                }
                .padding()
            }
            .navigationTitle(self.displayedTitle)
            .navigationDestination(for: RemoteMovie.self) { movie in
                MovieDetailView(movie: movie, data: nil)
            }
            .navigationDestination(for: LocalMovie.self) { movie in
                MovieDetailView(movie: movie, data: movie.imageData)
            }
            .toolbar {
                if self.selectedTab == .movies {
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
        }
        .task {
            await loadNextPageIfNeeded(forceFirstPage: true)
        }
        .onChange(of: selectedCategory) { _, _ in
            guard selectedTab == .movies else { return }
            self.remoteMovies = []
            self.currentPage = 0
            self.totalPages = 1
            Task { await loadNextPageIfNeeded(forceFirstPage: true) }
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
            
            nextPage == 1 ? self.remoteMovies = response.results : self.remoteMovies.append(contentsOf: response.results)
        } catch {
            self.errorText = error.localizedDescription
        }
    }
}

