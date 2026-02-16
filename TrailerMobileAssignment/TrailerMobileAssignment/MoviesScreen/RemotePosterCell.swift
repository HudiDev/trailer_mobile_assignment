//
//  RemotePosterCell.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/14/26.
//

import SwiftUI


struct RemotePosterCell: View {
    let movie: any Movie
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var isSaving = false
    
    var body: some View {
        PosterCell(isFavorite: favoritesStore.isFavorite(movie), isSaving: self.isSaving) {
            isSaving = true
            defer { isSaving = false }
            if let url = movie.posterURL {
                Task {
                    guard let imageData = try? await URLSession.shared.data(from: url).0 else { return }
                    self.favoritesStore.toggleFavorite(self.movie, imageData: imageData)
                }
            }
        } poster: {
            AsyncImage(url: self.movie.posterURL) { phase in
                switch phase {
                case .empty:
                    ZStack { RoundedRectangle(cornerRadius: 12).fill(.thinMaterial); ProgressView() }
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.thinMaterial)
                        Image(systemName: "film")
                    }
                @unknown default:
                    RoundedRectangle(cornerRadius: 12).fill(.thinMaterial)
                }
            }
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.quaternary, lineWidth: 1)
            )
        }
    }
}
