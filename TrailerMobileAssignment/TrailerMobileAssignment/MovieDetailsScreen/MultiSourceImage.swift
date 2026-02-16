//
//  MultiSourceImage.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import SwiftUI

struct MultiSourceImage: View {
    
    let imageData: Data?
    let url: URL?
    
    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                AsyncImage(url: self.url) { phase in
                    switch phase {
                    case .empty:
                        ZStack { RoundedRectangle(cornerRadius: 14).fill(.thinMaterial); ProgressView() }
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        ZStack { RoundedRectangle(cornerRadius: 14).fill(.thinMaterial); Image(systemName: "film") }
                    @unknown default:
                        RoundedRectangle(cornerRadius: 14).fill(.thinMaterial)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

