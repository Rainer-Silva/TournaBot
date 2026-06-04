import Foundation

final class StorageService {
    static let shared = StorageService()

    private enum Keys {
        static let playlist = "openStreamIPTV.playlist"
        static let favoriteIDs = "openStreamIPTV.favoriteIDs"
        static let playlistURL = "openStreamIPTV.playlistURL"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func savePlaylist(_ playlist: Playlist) {
        if let data = try? encoder.encode(playlist) {
            defaults.set(data, forKey: Keys.playlist)
        }
        defaults.set(playlist.sourceURL?.absoluteString, forKey: Keys.playlistURL)
    }

    func loadPlaylist() -> Playlist? {
        guard let data = defaults.data(forKey: Keys.playlist) else { return nil }
        return try? decoder.decode(Playlist.self, from: data)
    }

    func savePlaylistURLString(_ urlString: String) {
        defaults.set(urlString, forKey: Keys.playlistURL)
    }

    func loadPlaylistURLString() -> String {
        defaults.string(forKey: Keys.playlistURL) ?? ""
    }

    func saveFavoriteIDs(_ ids: Set<UUID>) {
        let strings = ids.map(\.uuidString)
        defaults.set(strings, forKey: Keys.favoriteIDs)
    }

    func loadFavoriteIDs() -> Set<UUID> {
        let strings = defaults.stringArray(forKey: Keys.favoriteIDs) ?? []
        return Set(strings.compactMap(UUID.init(uuidString:)))
    }
}
