//
//  MoviesService.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/17/26.
//

import Foundation


class MoviesService {
    static func getMovies(selectedCategory: MovieCategory, currentPage: Int) async throws -> MoviesResponse {
        switch selectedCategory {
        case .nowPlaying:
            try await MoviesApi.nowPlaying(page: currentPage).request(ResponseType: MoviesResponse.self)
        case .upcoming:
            try await MoviesApi.upcoming(page: currentPage).request(ResponseType: MoviesResponse.self)
        case .topRated:
            try await MoviesApi.topRated(page: currentPage).request(ResponseType: MoviesResponse.self)
        }
    }
}
