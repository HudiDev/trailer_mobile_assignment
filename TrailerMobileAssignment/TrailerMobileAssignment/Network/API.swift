//
//  API.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import Foundation


enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol API {
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var urlComponents: URLComponents { get }
    var params: [URLQueryItem] { get }
    var urlRequest: URLRequest { get }
    func request<Response: Decodable>(ResponseType: Response.Type) async throws -> Response
}

extension API {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org")!
    }
    
    // TODO: - fix safety issue with exposed token
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.urlComponents.url!)
        request.httpMethod = self.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmN2Q4ODliNGU3NmQ3MDkxYmJlYzBhMjQ0ZDI2MDliZSIsIm5iZiI6MTc3MDk4NjY1MS4wNzMsInN1YiI6IjY5OGYxYzliOGU5MzcxMjY2NTJmMzI2MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6_wWmF7NOCK3FwBpglOvL80SEptCltt_6_IrSjJd2sY", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
