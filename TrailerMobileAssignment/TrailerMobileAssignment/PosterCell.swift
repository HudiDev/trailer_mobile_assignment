//
//  PosterCell.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/14/26.
//

import SwiftUI


struct PosterCell: View {
    let url: URL?
    let title: String
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack { RoundedRectangle(cornerRadius: 12).fill(.thinMaterial); ProgressView() }
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.thinMaterial)
                    Image(systemName: "film")
                }
            @unknown default:
                RoundedRectangle(cornerRadius: 12).fill(.thinMaterial)
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
}
