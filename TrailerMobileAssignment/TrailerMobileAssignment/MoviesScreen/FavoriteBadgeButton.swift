//
//  FavoriteBadgeButton.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/16/26.
//

import SwiftUI

struct FavoriteBadgeButton: View {
    let isFavorite: Bool
    let isSaving: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(.ultraThinMaterial)
                if isSaving {
                    ProgressView().controlSize(.mini)
                } else {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .symbolRenderingMode(.hierarchical)
                }
            }
            .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
    }
}
