# Open Stream IPTV

Open Stream IPTV is a private/family-use iPhone-first MVP for playing personal network media playlists. It is a neutral SwiftUI media player that lets users add their own M3U playlist URL or import their own local `.m3u` file, browse parsed streams, favorite channels, and play compatible streams with AVPlayer.

> **Disclaimer:** This app does not provide content. Users are responsible for the playlists and streams they add.

## Product and legal positioning

- This project is a generic personal network stream player.
- The repository does **not** include, bundle, suggest, scrape, hardcode, or recommend IPTV playlists, TV channels, copyrighted streams, channel logos, or illegal content sources.
- The app should not be marketed as free premium TV or with claims about paid channels, sports, movies, or copyrighted programming.
- Users must provide their own M3U playlist URL or local M3U file.

## Phase 1 MVP scope

Phase 1 is iOS only and intentionally local-first:

- Swift + SwiftUI
- AVKit / AVPlayer playback
- Local storage only using `UserDefaults` JSON encoding
- No backend
- No login
- No analytics
- No subscriptions
- No App Store publishing setup
- No external dependencies

## Features

- Home screen branded as **Open Stream IPTV**.
- Add playlist by pasting an M3U URL.
- Optional local `.m3u` file import from the iOS document picker.
- M3U parsing for common fields:
  - `#EXTINF`
  - channel name
  - `tvg-name`
  - `tvg-logo`
  - `group-title`
  - stream URL on the following line
- Channel list with channel names, categories/groups, search, and group filtering.
- Favorites: mark/unmark channels and view a Favorites section.
- AVPlayer playback for HLS `.m3u8` and normal HTTP stream URLs.
- Friendly playback/load error messages.
- Local persistence for playlist URL, parsed channels, and favorites.

## Repository structure

```text
apps/ios/OpenStreamIPTV/
  OpenStreamIPTV.xcodeproj/
  OpenStreamIPTV/
    Models/
    Services/
    ViewModels/
    Views/
  OpenStreamIPTVTests/
docs/
README.md
AGENTS.md
.gitignore
```

## Setup

1. Open `apps/ios/OpenStreamIPTV/OpenStreamIPTV.xcodeproj` in Xcode.
2. Select the `OpenStreamIPTV` scheme.
3. Choose an iPhone simulator or device.
4. Build and run.
5. Add your own M3U playlist URL or import your own local `.m3u` file.

## Running tests

In Xcode, run the `OpenStreamIPTVTests` test target. The tests cover basic M3U parsing behavior.

A Swift Package manifest is also included for parser-only validation in environments without Xcode:

```bash
cd apps/ios/OpenStreamIPTV
swift test
```

## Architecture notes

The MVP uses a small, readable SwiftUI structure:

- `Models` define playlist/channel data.
- `Services` handle M3U parsing, playlist loading, and local persistence.
- `ViewModels` keep UI state and user actions out of views.
- `Views` contain SwiftUI screens and AVPlayer integration.

Core playlist parsing is dependency-free and platform-neutral so it can be unit tested outside of the UI.

## Future roadmap

Documentation-only ideas for later phases:

- Samsung TV Tizen app
- EPG/XMLTV support
- Parental controls
- Playlist health check
- iCloud sync
- AirPlay/Chromecast investigation
