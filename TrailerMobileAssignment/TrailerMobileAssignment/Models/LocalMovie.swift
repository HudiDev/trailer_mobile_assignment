//
//  LocalMovie.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//


import CoreData

class LocalMovie: NSManagedObject, Movie {
    @NSManaged var id: Int
    @NSManaged var title: String
    @NSManaged var overview: String
    @NSManaged var posterPath: String
    @NSManaged var releaseDate: String
    @NSManaged var voteAverage: Double
    @NSManaged var imageData: Data?
    @NSManaged var imageSavedAt: Date
}
