//
//  Movie.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import Foundation


protocol Movie {
    var id: Int { get }
    var title: String { get }
    var overview: String { get }
    var posterPath: String { get }
    var releaseDate: String { get }
    var voteAverage: Double { get }
}

extension Movie {
    var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }
    
    var releaseDateText: String {
        guard !releaseDate.isEmpty else { return "—" }
        
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"
        
        guard let date = parser.date(from: releaseDate) else {
            return releaseDate
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
}
