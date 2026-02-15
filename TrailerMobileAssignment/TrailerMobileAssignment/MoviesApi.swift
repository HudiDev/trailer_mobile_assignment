//
//  MoviesApi.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import Foundation

struct Movie: Decodable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var ratingText: String {
        guard let voteAverage else { return "—" }
        return String(format: "%.1f", voteAverage)
    }
}

extension Movie {
    var releaseDateText: String {
        guard let releaseDate, !releaseDate.isEmpty else { return "—" }

        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"

        guard let date = parser.date(from: releaseDate) else {
            return releaseDate // fallback: show raw string
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium   // Jan 7, 2026
        formatter.timeStyle = .none

        return formatter.string(from: date)
    }
}

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

enum MovieCategory: String, CaseIterable, Identifiable {
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"

    var id: String { rawValue }

    var path: String {
        switch self {
        case .nowPlaying: return "now_playing"
        case .upcoming:   return "upcoming"
        case .topRated:   return "top_rated"
        }
    }
}

func fetchNowPlaying(category: MovieCategory, page: Int = 1) async throws -> MoviesResponse {
    var components = URLComponents(string: "https://api.themoviedb.org/3/movie/\(category.path)")!
    components.queryItems = [
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "page", value: String(page))
    ]
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmN2Q4ODliNGU3NmQ3MDkxYmJlYzBhMjQ0ZDI2MDliZSIsIm5iZiI6MTc3MDk4NjY1MS4wNzMsInN1YiI6IjY5OGYxYzliOGU5MzcxMjY2NTJmMzI2MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6_wWmF7NOCK3FwBpglOvL80SEptCltt_6_IrSjJd2sY", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(MoviesResponse.self, from: data)
}
