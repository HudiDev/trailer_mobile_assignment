//
//  LocalMovieGrid.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import SwiftUI


struct LocalMovieGrid: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    
    var body: some View {
        ForEach(self.favoritesStore.favorites, id: \.id) { movie in
            NavigationLink(value: movie) {
                LocalPosterCell(movie: movie)
            }
            .id("local-\(movie.id)")
            .buttonStyle(.plain)
        }
    }
}
