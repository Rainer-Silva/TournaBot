import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@MainActor
final class PlaylistLoader {
    private let parser: M3UParser
    private let session: URLSession

    init(parser: M3UParser = M3UParser(), session: URLSession = .shared) {
        self.parser = parser
        self.session = session
    }

    func load(from url: URL) async throws -> Playlist {
        let (data, response) = try await session.data(from: url)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw PlaylistLoaderError.httpStatus(httpResponse.statusCode)
        }

        guard let text = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1) else {
            throw PlaylistLoaderError.unreadableData
        }

        return Playlist(sourceURL: url, channels: try parser.parse(text))
    }

    func load(fromLocalFile url: URL) throws -> Playlist {
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing { url.stopAccessingSecurityScopedResource() }
        }

        let data = try Data(contentsOf: url)
        guard let text = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1) else {
            throw PlaylistLoaderError.unreadableData
        }

        return Playlist(sourceURL: nil, channels: try parser.parse(text))
    }
}

enum PlaylistLoaderError: LocalizedError, Equatable {
    case httpStatus(Int)
    case unreadableData

    var errorDescription: String? {
        switch self {
        case .httpStatus(let statusCode):
            return "The playlist could not be downloaded (HTTP \(statusCode))."
        case .unreadableData:
            return "The playlist file could not be read as text."
        }
    }
}
