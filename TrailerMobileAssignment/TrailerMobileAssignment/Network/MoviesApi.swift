//
//  MoviesApi.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import Foundation
import CoreData


enum MovieCategory: String, CaseIterable, Identifiable {
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    
    var id: String { rawValue }
    
    var path: String {
        switch self {
        case .nowPlaying: return "now_playing"
        case .upcoming: return "upcoming"
        case .topRated: return "top_rated"
        }
    }
}

enum MoviesApi: API {
    
    case nowPlaying(page: Int)
    case upcoming(page: Int)
    case topRated(page: Int)
    
    var path: String {
        switch self {
        case .nowPlaying:
            "now_playing"
        case .upcoming:
            "upcoming"
        case .topRated:
            "top_rated"
        }
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var params: [URLQueryItem] {
        switch self {
        case let .nowPlaying(page), let .upcoming(page), let .topRated(page):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: String(page))
            ]
        }
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.path = "/3/movie/\(self.path)"
        components.queryItems = self.params
        return components
    }
    
    func request<Response>(ResponseType: Response.Type) async throws -> Response where Response : Decodable {
        let (data, response) = try await URLSession.shared.data(for: self.urlRequest)
        
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(ResponseType.self, from: data)
    }
    
}

//func fetchNowPlaying(category: MovieCategory, page: Int = 1) async throws -> MoviesResponse {
//    var components = URLComponents(string: "https://api.themoviedb.org/3/movie/\(category.path)")!
//    components.queryItems = [
//        URLQueryItem(name: "language", value: "en-US"),
//        URLQueryItem(name: "page", value: String(page))
//    ]
//    
//    var request = URLRequest(url: components.url!)
//    request.httpMethod = "GET"
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//    request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmN2Q4ODliNGU3NmQ3MDkxYmJlYzBhMjQ0ZDI2MDliZSIsIm5iZiI6MTc3MDk4NjY1MS4wNzMsInN1YiI6IjY5OGYxYzliOGU5MzcxMjY2NTJmMzI2MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6_wWmF7NOCK3FwBpglOvL80SEptCltt_6_IrSjJd2sY", forHTTPHeaderField: "Authorization")
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    
//    guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
//        throw URLError(.badServerResponse)
//    }
//    
//    return try JSONDecoder().decode(MoviesResponse.self, from: data)
//}
