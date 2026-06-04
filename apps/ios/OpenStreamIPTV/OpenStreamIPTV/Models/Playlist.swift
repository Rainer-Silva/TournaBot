import Foundation

struct Playlist: Codable, Equatable {
    var sourceURL: URL?
    var loadedAt: Date
    var channels: [Channel]

    init(sourceURL: URL? = nil, loadedAt: Date = Date(), channels: [Channel] = []) {
        self.sourceURL = sourceURL
        self.loadedAt = loadedAt
        self.channels = channels
    }
}
