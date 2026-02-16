//
//  PosterCell.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//


import SwiftUI

struct PosterCell<Poster: View>: View {
    let isFavorite: Bool
    let isSaving: Bool
    let onToggle: () -> Void
    @ViewBuilder let poster: () -> Poster

    var body: some View {
        ZStack(alignment: .topTrailing) {
            poster()
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.quaternary, lineWidth: 1)
                )

            FavoriteBadgeButton(
                isFavorite: isFavorite,
                isSaving: isSaving,
                action: onToggle
            )
            .padding(8)
        }
    }
}
