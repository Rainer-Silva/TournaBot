import Foundation
import Combine

@MainActor
final class ChannelListViewModel: ObservableObject {
    @Published var playlistURLString: String
    @Published private(set) var channels: [Channel]
    @Published private(set) var favoriteIDs: Set<UUID>
    @Published var searchText = ""
    @Published var selectedGroup = "All"
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let loader: PlaylistLoader
    private let storage: StorageService

    init(loader: PlaylistLoader = PlaylistLoader(), storage: StorageService = .shared) {
        self.loader = loader
        self.storage = storage
        self.playlistURLString = storage.loadPlaylistURLString()
        self.channels = storage.loadPlaylist()?.channels ?? []
        self.favoriteIDs = storage.loadFavoriteIDs()
    }

    var disclaimer: String {
        "This app does not provide content. Users are responsible for the playlists and streams they add."
    }

    var groups: [String] {
        let values = Set(channels.map(\.displayGroup))
        return ["All"] + values.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    var filteredChannels: [Channel] {
        channels.filter { channel in
            let matchesSearch = searchText.isEmpty || channel.displayName.localizedCaseInsensitiveContains(searchText)
            let matchesGroup = selectedGroup == "All" || channel.displayGroup == selectedGroup
            return matchesSearch && matchesGroup
        }
    }

    var favoriteChannels: [Channel] {
        channels.filter { favoriteIDs.contains($0.id) }
    }

    func loadRemotePlaylist() async {
        let trimmed = playlistURLString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed), let scheme = url.scheme, ["http", "https"].contains(scheme.lowercased()) else {
            errorMessage = "Enter a valid http or https M3U playlist URL."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let playlist = try await loader.load(from: url)
            apply(playlist)
            storage.savePlaylistURLString(trimmed)
        } catch {
            errorMessage = friendlyMessage(for: error)
        }
    }

    func importLocalPlaylist(from url: URL) {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            apply(try loader.load(fromLocalFile: url))
        } catch {
            errorMessage = friendlyMessage(for: error)
        }
    }

    func isFavorite(_ channel: Channel) -> Bool {
        favoriteIDs.contains(channel.id)
    }

    func toggleFavorite(_ channel: Channel) {
        if favoriteIDs.contains(channel.id) {
            favoriteIDs.remove(channel.id)
        } else {
            favoriteIDs.insert(channel.id)
        }
        storage.saveFavoriteIDs(favoriteIDs)
    }

    private func apply(_ playlist: Playlist) {
        channels = playlist.channels
        let validIDs = Set(playlist.channels.map(\.id))
        favoriteIDs = favoriteIDs.intersection(validIDs)
        if !groups.contains(selectedGroup) { selectedGroup = "All" }
        storage.savePlaylist(playlist)
        storage.saveFavoriteIDs(favoriteIDs)
    }

    private func friendlyMessage(for error: Error) -> String {
        if let localizedError = error as? LocalizedError,
           let message = localizedError.errorDescription {
            return message
        }
        return "The playlist could not be loaded. Please check the URL or file and try again."
    }
}
