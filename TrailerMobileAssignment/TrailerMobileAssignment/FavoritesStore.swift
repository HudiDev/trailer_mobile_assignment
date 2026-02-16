//
//  FavoritesStore.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import SwiftUI


@MainActor
class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [LocalMovie] = []
    
    private let repository = MovieRepository()
    
    init() {
        self.favorites = self.repository.fetchFavorites()
    }
    
    func load() {
        self.favorites = self.repository.fetchFavorites()
    }
    
    func isFavorite(_ movie: any Movie) -> Bool {
        self.favorites.contains { $0.id == movie.id }
    }
    
    func toggleFavorite(_ movie: any Movie, imageData: Data?) {
        if let existing = favorites.first(where: { $0.id == movie.id }) {
            self.repository.deleteFavorite(existing)
        } else if let imageData {
            self.repository.saveFavorite(movie: movie, imageData: imageData)
        }
        load()  // Refresh the list
    }
}
