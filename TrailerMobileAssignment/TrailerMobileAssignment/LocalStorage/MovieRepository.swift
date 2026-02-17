//
//  MovieRepository.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/15/26.
//

import Foundation
import CoreData


class MovieRepository {
    func saveFavorite(movie: Movie, imageData: Data) {
        let context = PersistenceManager.shared.context
        
        let favorite = LocalMovie(context: context)
        favorite.id = movie.id
        favorite.title = movie.title
        favorite.overview = movie.overview
        favorite.posterPath = movie.posterPath
        favorite.releaseDate = movie.releaseDate
        favorite.voteAverage = movie.voteAverage
        favorite.imageData = imageData
        favorite.imageSavedAt = Date()
        
        PersistenceManager.shared.save()
    }
    
    func fetchFavorites() -> [LocalMovie] {
        let context = PersistenceManager.shared.context
        let request = NSFetchRequest<LocalMovie>(entityName: "LocalMovie")
        
        do {
            let movies = try context.fetch(request)
            return movies
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    func deleteFavorite(_ favorite: LocalMovie) {
        let context = PersistenceManager.shared.context
        context.delete(favorite)
        PersistenceManager.shared.save()
    }
}
