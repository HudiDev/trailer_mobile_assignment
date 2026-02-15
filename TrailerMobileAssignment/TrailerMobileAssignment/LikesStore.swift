//
//  LikesStore.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/15/26.
//

import SwiftUI

@MainActor
final class LikesStore: ObservableObject {
    @Published private(set) var likedMovies: [Movie] = []

    private let key = "liked_movies"

    init() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        if let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            likedMovies = decoded
        }
    }

    func isLiked(_ id: Int) -> Bool {
        likedMovies.contains(where: { $0.id == id })
    }

    func toggle(movie: Movie) {
        if let idx = likedMovies.firstIndex(where: { $0.id == movie.id }) {
            likedMovies.remove(at: idx)
        } else {
            likedMovies.append(movie)
        }
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(likedMovies) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
