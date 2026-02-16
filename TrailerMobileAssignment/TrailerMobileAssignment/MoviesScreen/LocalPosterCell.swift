//
//  LocalPosterCell.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/15/26.
//


import SwiftUI


struct LocalPosterCell: View {
    let movie: LocalMovie
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var isSaving = false
    
    var body: some View {
        PosterCell(isFavorite: self.favoritesStore.isFavorite(movie), isSaving: self.isSaving) {
            isSaving = true
            defer { isSaving = false }
            self.favoritesStore.removeFavorite(self.movie)
        } poster: {
            if let data = self.movie.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                RemotePosterCell(movie: self.movie)
            }
        }
    }
}
