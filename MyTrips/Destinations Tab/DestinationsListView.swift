//
// Created for MyTrips
// by  Stewart Lynch on 2024-01-06
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI
import SwiftData

struct DestinationsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.name) private var destinations: [Destination]
    @State private var newDestination = false
    @State private var destinationName = ""
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !destinations.isEmpty{
                    List(destinations) { destination in
                        NavigationLink(value: destination){
                            HStack {
                                Image(systemName: "globe")
                                    .imageScale(.large)
                                    .foregroundStyle(.accent)
                                VStack(alignment: .leading) {
                                    Text(destination.name)
                                    Text("^[\(destination.placemarks.count) location](inflect: true)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(destination)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .navigationDestination(for: Destination.self) { destination in
                        DestinationLocationsMapView(destination: destination)
                    }
                } else {
                    ContentUnavailableView(
                        "No Destinations",
                        systemImage: "globe.desk",
                        description: Text("You have not set up any destinations yet.  Tap on the \(Image(systemName: "plus.circle.fill")) button in the toolbar to begin.")
                    )
                }
            }
            .navigationTitle("My Destinations")
            .toolbar {
                Button {
                    newDestination.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .alert(
                    "Enter Destination Name",
                    isPresented: $newDestination) {
                        TextField("Enter destination name", text: $destinationName)
                            .autocorrectionDisabled()
                        Button("OK") {
                            if !destinationName.isEmpty {
                                let destination = Destination(name: destinationName.trimmingCharacters(in: .whitespacesAndNewlines))
                                modelContext.insert(destination)
                                destinationName = ""
                                path.append(destination)
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Create a new destination")
                    }

            }
        }
    }
}

#Preview {
    DestinationsListView()
        .modelContainer(Destination.preview)
}
