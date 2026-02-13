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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(self.movies, id: \.id) { movie in
                        Text(movie.title)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
            .navigationTitle("Movies")
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

