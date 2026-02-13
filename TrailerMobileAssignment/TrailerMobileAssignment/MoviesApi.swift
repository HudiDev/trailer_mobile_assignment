//
//  MoviesApi.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let posterUrl: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterUrl = "poster_path"
    }
}

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
}


func fetchNowPlaying(page: Int = 1) async throws -> MoviesResponse {
    var components = URLComponents(string: "https://api.themoviedb.org/3/movie/now_playing")!
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
