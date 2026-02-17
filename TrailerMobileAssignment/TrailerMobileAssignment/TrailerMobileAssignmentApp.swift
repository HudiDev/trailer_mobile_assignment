//
//  TrailerMobileAssignmentApp.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import SwiftUI

@main
struct TrailerMobileAssignmentApp: App {
    @StateObject private var favoritesStore = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            MoviesView()
                .environmentObject(favoritesStore)
        }
    }
}
