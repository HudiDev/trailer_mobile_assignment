//
//  RemoteMovie.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//


struct RemoteMovie: Movie, Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}