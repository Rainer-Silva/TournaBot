import SwiftUI
import UniformTypeIdentifiers

struct AddPlaylistView: View {
    @ObservedObject var viewModel: ChannelListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isImporterPresented = false

    var body: some View {
        Form {
            Section("Important") {
                Text(viewModel.disclaimer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("M3U Playlist URL") {
                TextField("https://example.com/your-playlist.m3u", text: $viewModel.playlistURLString)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()

                Button {
                    Task {
                        await viewModel.loadRemotePlaylist()
                        if viewModel.errorMessage == nil { dismiss() }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Label("Load Playlist URL", systemImage: "arrow.down.circle")
                    }
                }
                .disabled(viewModel.isLoading)
            }

            Section("Local File") {
                Button {
                    isImporterPresented = true
                } label: {
                    Label("Import .m3u File", systemImage: "doc.badge.plus")
                }
                .disabled(viewModel.isLoading)
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Add Playlist")
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.mpegURL, .plainText, .text],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    viewModel.importLocalPlaylist(from: url)
                    if viewModel.errorMessage == nil { dismiss() }
                }
            case .failure(let error):
                viewModel.errorMessage = "The selected file could not be imported: \(error.localizedDescription)"
            }
        }
    }
}
