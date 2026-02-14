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
            do {
                let response = try await fetchNowPlaying(page: 1)
                self.movies = response.results
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
}

