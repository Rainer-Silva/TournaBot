import Foundation

struct Channel: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var tvgName: String?
    var logoURL: URL?
    var groupTitle: String?
    var streamURL: URL

    init(
        id: UUID = UUID(),
        name: String,
        tvgName: String? = nil,
        logoURL: URL? = nil,
        groupTitle: String? = nil,
        streamURL: URL
    ) {
        self.id = id
        self.name = name
        self.tvgName = tvgName
        self.logoURL = logoURL
        self.groupTitle = groupTitle
        self.streamURL = streamURL
    }

    var displayName: String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty { return trimmedName }

        let trimmedTvgName = tvgName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmedTvgName.isEmpty ? "Untitled Stream" : trimmedTvgName
    }

    var displayGroup: String {
        let trimmedGroup = groupTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmedGroup.isEmpty ? "Ungrouped" : trimmedGroup
    }
}
