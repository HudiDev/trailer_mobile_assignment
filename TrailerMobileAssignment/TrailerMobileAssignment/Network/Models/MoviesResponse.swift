//
//  MoviesResponse.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//


struct MoviesResponse: Codable {
    let page: Int
    let results: [RemoteMovie]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
