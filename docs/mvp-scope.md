# MVP Scope

Open Stream IPTV Phase 1 is an iOS-only, local-first SwiftUI MVP for personal/family playlist playback.

## In scope

- User-provided M3U URL input.
- User-provided local `.m3u` file import.
- M3U parsing for `#EXTINF`, `tvg-name`, `tvg-logo`, `group-title`, channel name, and stream URL.
- Searchable/filterable channel list.
- Favorite channels.
- AVPlayer playback for compatible stream URLs.
- Local-only persistence.

## Out of scope

- Bundled playlists or sample stream sources.
- Scraping or discovering content.
- Backend services, login, analytics, subscriptions, or cloud sync.
- App Store publishing setup.
- Copyrighted logos, channels, streams, or marketing examples.

## Required disclaimer

“This app does not provide content. Users are responsible for the playlists and streams they add.”
