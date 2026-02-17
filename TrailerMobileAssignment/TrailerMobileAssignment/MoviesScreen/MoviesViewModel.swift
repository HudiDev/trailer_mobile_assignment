//
//  MoviesViewModel.swift
//  TrailerMobileAssignment
//
//  Created by Yehuda Ilfeld on 2/17/26.
//

import Foundation


@MainActor
final class MoviesViewModel: ObservableObject {


    @Published private(set) var remoteMovies: [RemoteMovie] = []
    @Published private(set) var errorText: String?
    @Published private(set) var isLoadingNextPage = false

    @Published var selectedCategory: MovieCategory = .nowPlaying
    @Published var selectedTab: TopTab = .movies

    private var currentPage = 0
    private var totalPages = 1


    var title: String {
        "\(selectedTab == .movies ? selectedCategory.rawValue : "Favorite") Movies"
    }


    func onFirstAppear() async {
        if selectedTab == .movies {
            await reloadRemoteFirstPage()
        }
    }

    func onCategoryChanged() async {
        guard selectedTab == .movies else { return }
        await reloadRemoteFirstPage()
    }

    func onTabChanged(_ newTab: TopTab) async {
        selectedTab = newTab

        // If user goes back to Movies tab, ensure we have data
        if newTab == .movies, remoteMovies.isEmpty {
            await reloadRemoteFirstPage()
        }
    }

    func onLastRemoteMovieAppeared(lastMovieID: Int?) async {
        guard selectedTab == .movies else { return }
        guard lastMovieID == remoteMovies.last?.id else { return }
        await loadNextPageIfNeeded()
    }

    // MARK: - Private

    private func reloadRemoteFirstPage() async {
        remoteMovies = []
        errorText = nil
        currentPage = 0
        totalPages = 1
        await loadNextPageIfNeeded(forceFirstPage: true)
    }

    private func loadNextPageIfNeeded(forceFirstPage: Bool = false) async {
        if isLoadingNextPage { return }
        if !forceFirstPage, currentPage >= totalPages { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let nextPage = forceFirstPage ? 1 : (currentPage + 1)
            let response = try await MoviesService.getMovies(selectedCategory: selectedCategory, currentPage: nextPage)

            currentPage = response.page
            totalPages = response.totalPages

            if nextPage == 1 {
                remoteMovies = response.results
            } else {
                remoteMovies.append(contentsOf: response.results)
            }
        } catch {
            errorText = error.localizedDescription
        }
    }
}
