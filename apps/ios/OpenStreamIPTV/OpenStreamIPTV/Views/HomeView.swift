import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ChannelListViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Open Stream IPTV")
                            .font(.largeTitle.bold())
                        Text(viewModel.disclaimer)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    if viewModel.channels.isEmpty {
                        ContentUnavailableView(
                            "Add Your Playlist",
                            systemImage: "play.rectangle.on.rectangle",
                            description: Text("Paste your own M3U URL or import your own local .m3u file to get started.")
                        )
                    } else {
                        ChannelListView(viewModel: viewModel)
                    }
                }
                .navigationTitle("Open Stream IPTV")
                .toolbar {
                    NavigationLink {
                        AddPlaylistView(viewModel: viewModel)
                    } label: {
                        Label("Add Playlist", systemImage: "plus")
                    }
                }
            }
            .tabItem { Label("Channels", systemImage: "list.bullet") }

            NavigationStack {
                FavoritesView(viewModel: viewModel)
                    .navigationTitle("Favorites")
            }
            .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
    }
}

#Preview {
    HomeView()
}
