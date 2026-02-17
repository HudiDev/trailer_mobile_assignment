# TrailerMobileAssignment (SwiftUI + TMDB)

A lightweight SwiftUI app that browses TMDB movies with pagination, supports category switching, and lets users favorite movies locally (Core Data) with offline-friendly poster rendering.

---

## Features

### Movies
- Browse movies from TMDB
- Categories:
  - Now Playing
  - Upcoming
  - Top Rated
- Infinite scrolling (pagination)
- Movie details screen:
  - Poster
  - Overview
  - Release date
  - Rating

### Favorites (Local)
- “Heart” button on:
  - Movie details toolbar
  - Each movie poster cell in the grid
- Favorites are stored locally using Core Data
- Favorites tab displays locally persisted favorites

### Images
- Posters are loaded via `AsyncImage` (TMDB CDN).
- When a movie is favorited, the poster `Data` is stored in Core Data for instant local rendering.
- Stored image data is purged (set to `nil`) if `imageSavedAt` is older than 24 hours (keeps the favorite, drops the cached bytes).

---

## Architecture

### MVVM
- **MoviesView**: UI only (renders grid, picker, toolbar, navigation)
- **MoviesViewModel**: remote movies business logic
  - paging (`currentPage`, `totalPages`, `isLoadingNextPage`)
  - category switching
  - error handling
- **MoviesService / MoviesApi**: networking and decoding
- **FavoritesStore** (`ObservableObject`, `@MainActor`): local favorites domain logic
- **MovieRepository**: Core Data CRUD
- **PersistenceManager**: Core Data stack

---

## Data Flow

### Remote movies
1. ViewModel requests a page via `MoviesService`
2. Results append into `remoteMovies`
3. Grid triggers next page when last cell appears

### Favorites
- Tapping heart toggles favorite:
  - Save/delete `LocalMovie` in Core Data
  - Refresh favorites list in `FavoritesStore`
- Favorites UI reads directly from `FavoritesStore.favorites` so the grid updates immediately.

---

## Setup

### Requirements
- Xcode 15+ (SwiftUI + Concurrency)
- iOS 17+ recommended

### TMDB Token
This project uses TMDB v4 Read Access Token (Bearer).

**Do not hardcode the token in source for a real project.**  
For a take-home, the recommended setup is build-time injection:

1) Create a `Secrets.xcconfig` (do not commit it)
```xcconfig
TMDB_BEARER_TOKEN = your_token_here
