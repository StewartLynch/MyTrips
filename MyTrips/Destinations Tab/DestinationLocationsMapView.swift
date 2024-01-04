//
// Created for MyTrips
// by  Stewart Lynch on 2023-12-31
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @Query private var destinations: [Destination]
    @State private var destination: Destination?
    var body: some View {
        Map(position: $cameraPosition) {
            if let destination {
                ForEach(destination.placemarks) { placemark in
                    Marker(coordinate: placemark.coordinate) {
                        Label(placemark.name, systemImage: "star")
                    }
                    .tint(.yellow)
                }
            }
        }
        .onMapCameraChange(frequency: .onEnd){ context in
            visibleRegion = context.region
        }
        .onAppear {
            destination = destinations.first
            if let region = destination?.region {
                cameraPosition = .region(region)
            }
        }
    }
}

#Preview {
    DestinationLocationsMapView()
        .modelContainer(Destination.preview)
}
