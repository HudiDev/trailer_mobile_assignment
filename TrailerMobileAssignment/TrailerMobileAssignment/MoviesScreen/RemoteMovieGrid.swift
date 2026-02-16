//
//  MovieGrid.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import SwiftUI

struct RemoteMovieGrid: View {
    
    var movies: [RemoteMovie] = []
    let onLastMovie: () -> Void
    
    var body: some View {
        ForEach(self.movies, id: \.id) { movie in
            NavigationLink(value: movie) {
                RemotePosterCell(movie: movie)
                    .onAppear {
                        if movie.id == movies.last?.id {
                            self.onLastMovie()
                        }
                    }
                
            }
            .id("remote-\(movie.id)")
            .buttonStyle(.plain)
        }
    }
}
