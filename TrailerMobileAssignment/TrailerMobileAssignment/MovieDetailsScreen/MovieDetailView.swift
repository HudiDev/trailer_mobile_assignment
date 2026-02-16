//
//  MovieDetailView.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/14/26.
//


import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    
    let movie: any Movie
    @State private var isSaving = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                AsyncImage(url: movie.posterURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack { RoundedRectangle(cornerRadius: 14).fill(.thinMaterial); ProgressView() }
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        ZStack { RoundedRectangle(cornerRadius: 14).fill(.thinMaterial); Image(systemName: "film") }
                    @unknown default:
                        RoundedRectangle(cornerRadius: 14).fill(.thinMaterial)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    Label(movie.releaseDateText, systemImage: "calendar")
                    Label(movie.ratingText, systemImage: "star.fill")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                if !movie.overview.isEmpty {
                    Text(movie.overview)
                        .font(.body)
                        .padding(.top, 4)
                } else {
                    Text("No description available.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await toggleFavorite() }
                } label: {
                    if isSaving {
                        ProgressView()
                    } else {
                        Image(systemName: favoritesStore.isFavorite(movie) ? "heart.fill" : "heart")
                    }
                }
            }
        }
    }
    
    private func toggleFavorite() async {
        isSaving = true
        defer { isSaving = false }
        
        var imageData: Data? = nil
        if !favoritesStore.isFavorite(movie), let url = movie.posterURL {
            imageData = try? await URLSession.shared.data(from: url).0
        }
        favoritesStore.toggleFavorite(movie, imageData: imageData)
    }
}
