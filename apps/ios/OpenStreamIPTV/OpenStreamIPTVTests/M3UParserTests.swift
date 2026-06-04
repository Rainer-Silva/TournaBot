import XCTest
@testable import OpenStreamIPTVCore

final class M3UParserTests: XCTestCase {
    func testParsesExtInfAttributesAndFollowingStreamURL() throws {
        let playlist = """
        #EXTM3U
        #EXTINF:-1 tvg-name="Family Stream" tvg-logo="https://example.invalid/logo.png" group-title="Home",Visible Name
        https://media.example.invalid/live/stream.m3u8
        """

        let channels = try M3UParser().parse(playlist)

        XCTAssertEqual(channels.count, 1)
        XCTAssertEqual(channels[0].name, "Visible Name")
        XCTAssertEqual(channels[0].tvgName, "Family Stream")
        XCTAssertEqual(channels[0].logoURL?.absoluteString, "https://example.invalid/logo.png")
        XCTAssertEqual(channels[0].groupTitle, "Home")
        XCTAssertEqual(channels[0].streamURL.absoluteString, "https://media.example.invalid/live/stream.m3u8")
    }

    func testUsesTvgNameWhenExtInfHasNoVisibleName() throws {
        let playlist = """
        #EXTM3U
        #EXTINF:-1 tvg-name="Personal Camera" group-title="Private"
        http://192.0.2.10/feed
        """

        let channels = try M3UParser().parse(playlist)

        XCTAssertEqual(channels.count, 1)
        XCTAssertEqual(channels[0].displayName, "Personal Camera")
        XCTAssertEqual(channels[0].displayGroup, "Private")
    }

    func testSkipsCommentsAndInvalidStreamLines() throws {
        let playlist = """
        #EXTM3U
        # This is a comment
        not a url
        #EXTINF:-1 group-title="Local",Local Stream
        https://media.example.invalid/stream.mp4
        """

        let channels = try M3UParser().parse(playlist)

        XCTAssertEqual(channels.map(\.displayName), ["Local Stream"])
    }

    func testThrowsWhenNoPlayableChannelsExist() {
        XCTAssertThrowsError(try M3UParser().parse("#EXTM3U\n#EXTINF:-1,Nothing")) { error in
            XCTAssertEqual(error as? M3UParserError, .noPlayableChannels)
        }
    }
}
