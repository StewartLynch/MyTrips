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

struct DestinationLocationsMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    var body: some View {
        Map(position: $cameraPosition) {
//            Marker(
//                "Moulin Rouge",
//                coordinate: CLLocationCoordinate2D(
//                    latitude: 48.884134,
//                    longitude: 2.332196
//                )
//            )
            Marker("Moulin Rouge", coordinate: .moulinRouge)
            Marker(coordinate: .arcDeTriomphe) {
                Label("Arc de Triomphe", systemImage: "star.fill")
            }
            .tint(.yellow)
            Marker("Eiffel Tower", image: "eiffelTower", coordinate: .eiffelTower)
                .tint(.blue)
            Marker("Gare du Nord", monogram: Text("GN"), coordinate: .gareDuNord)
                .tint(.accent)
            Marker("Louvre", systemImage: "person.crop.artframe", coordinate: .louvre)
                .tint(.appBlue)
            Annotation("Notre Dame", coordinate: .notreDame) {
                Image(systemName: "star")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .padding(10)
                    .background(.white)
                    .clipShape(.circle)
            }
            Annotation("Sacré Coeur", coordinate: .sacreCoeur, anchor: .center) {
                Image(.sacreCoeur)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            Annotation("Pantheon", coordinate: .pantheon) {
                Image(systemName: "mappin")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .padding(5)
                    .overlay {
                        Circle()
                            .strokeBorder(.red, lineWidth: 2)
                    }
            }
            MapCircle(
                center: CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077),
                radius: 5000
            )
            .foregroundStyle(.red.opacity(0.5))
        }
        .onMapCameraChange(frequency: .onEnd){ context in
            visibleRegion = context.region
        }
            .onAppear {
                // 48.856788, 2.351077
                let paris = CLLocationCoordinate2D(latitude: 48.856788, longitude: 2.351077)
                let parisSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
                let parisRegion = MKCoordinateRegion(center: paris, span: parisSpan)
                cameraPosition = .region(parisRegion)
            }
    }
}

#Preview {
    DestinationLocationsMapView()
}
