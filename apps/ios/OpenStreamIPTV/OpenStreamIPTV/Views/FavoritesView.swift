import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: ChannelListViewModel

    var body: some View {
        Group {
            if viewModel.favoriteChannels.isEmpty {
                ContentUnavailableView(
                    "No Favorites Yet",
                    systemImage: "star",
                    description: Text("Mark channels as favorites to find them here quickly.")
                )
            } else {
                List(viewModel.favoriteChannels) { channel in
                    NavigationLink {
                        PlayerView(channel: channel)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(channel.displayName)
                                .font(.headline)
                            Text(channel.displayGroup)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.toggleFavorite(channel)
                        } label: {
                            Label("Remove", systemImage: "star.slash")
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Text(viewModel.disclaimer)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .background(.bar)
        }
    }
}
