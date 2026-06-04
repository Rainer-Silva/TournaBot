import SwiftUI

struct ChannelListView: View {
    @ObservedObject var viewModel: ChannelListViewModel

    var body: some View {
        List {
            if !viewModel.favoriteChannels.isEmpty && viewModel.searchText.isEmpty && viewModel.selectedGroup == "All" {
                Section("Favorites") {
                    ForEach(viewModel.favoriteChannels) { channel in
                        channelRow(channel)
                    }
                }
            }

            Section("Channels") {
                ForEach(viewModel.filteredChannels) { channel in
                    channelRow(channel)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search channels")
        .safeAreaInset(edge: .top) {
            groupFilter
        }
        .overlay {
            if viewModel.filteredChannels.isEmpty && !viewModel.channels.isEmpty {
                ContentUnavailableView("No Channels Found", systemImage: "magnifyingglass", description: Text("Try a different search or group filter."))
            }
        }
    }

    private var groupFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.groups, id: \.self) { group in
                    Button {
                        viewModel.selectedGroup = group
                    } label: {
                        Text(group)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedGroup == group ? Color.accentColor : Color(.secondarySystemBackground))
                            .foregroundStyle(viewModel.selectedGroup == group ? .white : .primary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.bar)
    }

    private func channelRow(_ channel: Channel) -> some View {
        NavigationLink {
            PlayerView(channel: channel)
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(channel.displayName)
                        .font(.headline)
                    Text(channel.displayGroup)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    viewModel.toggleFavorite(channel)
                } label: {
                    Image(systemName: viewModel.isFavorite(channel) ? "star.fill" : "star")
                        .foregroundStyle(viewModel.isFavorite(channel) ? .yellow : .secondary)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(viewModel.isFavorite(channel) ? "Remove favorite" : "Add favorite")
            }
        }
    }
}
