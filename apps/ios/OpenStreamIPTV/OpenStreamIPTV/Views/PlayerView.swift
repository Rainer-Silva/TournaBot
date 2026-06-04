import AVKit
import SwiftUI

struct PlayerView: View {
    let channel: Channel

    @State private var player: AVPlayer?
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            if let player {
                VideoPlayer(player: player)
                    .frame(minHeight: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            } else {
                ProgressView("Preparing stream…")
                    .frame(minHeight: 260)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(channel.displayName)
                    .font(.title2.bold())
                Text(channel.displayGroup)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("This app does not provide content. Users are responsible for the playlists and streams they add.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            if let errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle("Now Playing")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: startPlayback)
        .onDisappear {
            player?.pause()
            player = nil
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemFailedToPlayToEndTime)) { notification in
            let message = (notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error)?.localizedDescription
            errorMessage = message ?? "Playback failed. Please verify that this stream is reachable and supported."
        }
    }

    private func startPlayback() {
        errorMessage = nil
        let playerItem = AVPlayerItem(url: channel.streamURL)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        player.play()
    }
}
