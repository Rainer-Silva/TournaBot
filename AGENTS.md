# AGENTS.md

## Project instructions for coding agents

- Keep changes small, focused, and reviewable.
- Do not add bundled playlists, sample IPTV feeds, copyrighted streams, channel lists, logos, or content-source recommendations.
- Treat this repository as a neutral personal network stream player. Do not market it as free premium TV.
- Do not introduce backend services, authentication, cloud sync, analytics, subscriptions, or App Store publishing setup unless explicitly requested.
- Prefer a simple SwiftUI architecture with lightweight MVVM: Models, ViewModels, Services, and Views.
- Avoid external dependencies unless clearly necessary and justified.
- Use local-only persistence unless a future task explicitly requests otherwise.
- Explain architectural decisions and tradeoffs in PR summaries.
- Keep legal/product positioning visible in user-facing documentation and UI: “This app does not provide content. Users are responsible for the playlists and streams they add.”
