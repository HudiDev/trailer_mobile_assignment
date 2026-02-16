//
//  LocalMovieGrid.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import SwiftUI


struct LocalMovieGrid: View {
    var movies: [LocalMovie] = []
    
    var body: some View {
        ForEach(self.movies, id: \.id) { movie in
            NavigationLink(value: movie) {
                LocalPosterCell(imageData: movie.imageData, url: movie.posterURL, title: movie.title)
            }
            .id("local-\(movie.id)")
            .buttonStyle(.plain)
        }
    }
}
