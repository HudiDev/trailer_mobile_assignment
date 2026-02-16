//
//  LocalPosterCell.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/15/26.
//


import SwiftUI


struct LocalPosterCell: View {
    let imageData: Data?
    let url: URL?
    let title: String?
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            RemotePosterCell(url: self.url)
        }
    }
}
