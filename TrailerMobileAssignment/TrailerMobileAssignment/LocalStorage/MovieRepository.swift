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

extension MovieRepository {

    func purgeExpiredImageData(olderThan seconds: TimeInterval = 24 * 60 * 60) {
        let context = PersistenceManager.shared.context
        let cutoff = Date().addingTimeInterval(-seconds)

        let request = NSBatchUpdateRequest(entityName: "LocalMovie")
        request.predicate = NSPredicate(format: "imageSavedAt < %@", cutoff as NSDate)


        request.propertiesToUpdate = ["imageData": NSNull()]

        // Ensure in-memory objects get refreshed
        request.resultType = .updatedObjectIDsResultType

        do {
            let result = try context.execute(request) as? NSBatchUpdateResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            if !objectIDs.isEmpty {
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSUpdatedObjectsKey: objectIDs],
                    into: [context]
                )
            }
        } catch {
            print("Purge imageData failed: \(error)")
        }
    }
}
