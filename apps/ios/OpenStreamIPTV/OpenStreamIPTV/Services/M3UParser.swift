import Foundation

enum M3UParserError: LocalizedError, Equatable {
    case emptyPlaylist
    case noPlayableChannels

    var errorDescription: String? {
        switch self {
        case .emptyPlaylist:
            return "The playlist is empty."
        case .noPlayableChannels:
            return "No playable stream URLs were found in this playlist."
        }
    }
}

struct M3UParser {
    func parse(_ text: String) throws -> [Channel] {
        let lines = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !lines.isEmpty else { throw M3UParserError.emptyPlaylist }

        var channels: [Channel] = []
        var pendingInfo: PendingInfo?

        for line in lines {
            if line.hasPrefix("#EXTINF") {
                pendingInfo = parseExtInf(line)
                continue
            }

            if line.hasPrefix("#") {
                continue
            }

            guard let streamURL = URL(string: line), streamURL.scheme != nil else {
                pendingInfo = nil
                continue
            }

            let info = pendingInfo
            let channel = Channel(
                name: resolvedName(from: info, fallbackURL: streamURL),
                tvgName: info?.attributes["tvg-name"],
                logoURL: info?.attributes["tvg-logo"].flatMap(URL.init(string:)),
                groupTitle: info?.attributes["group-title"],
                streamURL: streamURL
            )
            channels.append(channel)
            pendingInfo = nil
        }

        guard !channels.isEmpty else { throw M3UParserError.noPlayableChannels }
        return channels
    }

    private func parseExtInf(_ line: String) -> PendingInfo {
        let attributeText: String
        let rawName: String?

        if let commaIndex = line.firstIndex(of: ",") {
            attributeText = String(line[..<commaIndex])
            rawName = String(line[line.index(after: commaIndex)...])
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            attributeText = line
            rawName = nil
        }

        return PendingInfo(
            attributes: parseAttributes(attributeText),
            rawName: rawName?.isEmpty == true ? nil : rawName
        )
    }

    private func parseAttributes(_ text: String) -> [String: String] {
        var attributes: [String: String] = [:]
        let pattern = #"([A-Za-z0-9_-]+)="([^"]*)""#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return attributes }

        let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
        regex.enumerateMatches(in: text, range: nsRange) { match, _, _ in
            guard
                let match,
                match.numberOfRanges == 3,
                let keyRange = Range(match.range(at: 1), in: text),
                let valueRange = Range(match.range(at: 2), in: text)
            else { return }

            attributes[String(text[keyRange]).lowercased()] = String(text[valueRange])
        }

        return attributes
    }

    private func resolvedName(from info: PendingInfo?, fallbackURL: URL) -> String {
        if let rawName = info?.rawName, !rawName.isEmpty { return rawName }
        if let tvgName = info?.attributes["tvg-name"], !tvgName.isEmpty { return tvgName }
        return fallbackURL.lastPathComponent.isEmpty ? fallbackURL.absoluteString : fallbackURL.lastPathComponent
    }
}

private struct PendingInfo {
    let attributes: [String: String]
    let rawName: String?
}
