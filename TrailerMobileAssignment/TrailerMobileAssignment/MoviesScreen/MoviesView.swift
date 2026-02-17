//
//  ContentView.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/13/26.
//

import SwiftUI

enum TopTab: String, CaseIterable, Identifiable {
    case movies = "Movies"
    case favorites = "Favorites"
    var id: String { rawValue }
}

import SwiftUI

struct MoviesView: View {
    @StateObject private var vm = MoviesViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    Picker("", selection: $vm.selectedTab) {
                        ForEach(TopTab.allCases) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)

                    if let errorText = vm.errorText {
                        Text(errorText).foregroundStyle(.red)
                    }

                    LazyVGrid(columns: columns, spacing: 10) {
                        switch vm.selectedTab {
                        case .movies:
                            RemoteMovieGrid(movies: vm.remoteMovies) {
                                Task { await vm.onLastRemoteMovieAppeared(lastMovieID: vm.remoteMovies.last?.id) }
                            }
                        case .favorites:
                            LocalMovieGrid()
                        }
                    }

                    if vm.isLoadingNextPage {
                        ProgressView().padding(.vertical, 16)
                    }
                }
                .padding()
            }
            .navigationTitle(vm.title)
            .navigationDestination(for: RemoteMovie.self) { movie in
                MovieDetailView(movie: movie, data: nil)
            }
            .navigationDestination(for: LocalMovie.self) { movie in
                MovieDetailView(movie: movie, data: movie.imageData)
            }
            .toolbar {
                if vm.selectedTab == .movies {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Category", selection: $vm.selectedCategory) {
                                ForEach(MovieCategory.allCases) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                        } label: {
                            Label("Category", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
        }
        .task { await vm.onFirstAppear() }
        .onChange(of: vm.selectedCategory) { _, _ in Task { await vm.onCategoryChanged() } }
        .onChange(of: vm.selectedTab) { _, newTab in Task { await vm.onTabChanged(newTab) } }
    }
}

