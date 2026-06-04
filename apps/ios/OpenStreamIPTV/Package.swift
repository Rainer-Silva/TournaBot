// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OpenStreamIPTVParser",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "OpenStreamIPTVCore", targets: ["OpenStreamIPTVCore"])
    ],
    targets: [
        .target(
            name: "OpenStreamIPTVCore",
            path: "OpenStreamIPTV",
            exclude: [
                "OpenStreamIPTVApp.swift",
                "Info.plist",
                "Services/PlaylistLoader.swift",
                "Services/StorageService.swift",
                "ViewModels",
                "Views"
            ],
            sources: [
                "Models/Channel.swift",
                "Models/Playlist.swift",
                "Services/M3UParser.swift"
            ]
        ),
        .testTarget(
            name: "OpenStreamIPTVTests",
            dependencies: ["OpenStreamIPTVCore"],
            path: "OpenStreamIPTVTests",
            sources: ["M3UParserTests.swift"]
        )
    ]
)
