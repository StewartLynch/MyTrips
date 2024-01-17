//
// Created for MyTrips
// by  Stewart Lynch on 2024-01-09
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

struct LocationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var destination: Destination?
    var selectedPlacemark: MTPlacemark?
    @Binding var showRoute: Bool
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @Binding var travelInterval: TimeInterval?
    @Binding var transportType: MKDirectionsTransportType
    
    var travelTime: String? {
        guard let travelInterval else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: travelInterval)
    }
    
    @State private var name = ""
    @State private var address = ""
    
    var isChanged: Bool {
        guard let selectedPlacemark else { return false}
        return (name != selectedPlacemark.name || address != selectedPlacemark.address)
    }
    
    @State private var lookaroundScene: MKLookAroundScene?
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if destination != nil {
                        TextField("Name", text: $name)
                            .font(.title)
                        TextField("Address", text: $address, axis: .vertical)
                        if isChanged {
                            Button("Update") {
                                selectedPlacemark?.name = name
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                                selectedPlacemark?.address = address
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .buttonStyle(.bordered)
                            .autocorrectionDisabled()
                        }
                    } else {
                        Text(selectedPlacemark?.name ?? "")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(selectedPlacemark?.address ?? "")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.trailing)
                    }
                    if destination == nil {
                        HStack {
                            Button {
                                transportType = .automobile
                            } label: {
                                Image(systemName: "car")
                                    .symbolVariant(transportType == .automobile ? .circle : .none)
                                    .imageScale(.large)
                            }
                            Button {
                                transportType = .walking
                            } label: {
                                Image(systemName: "figure.walk")
                                    .symbolVariant(transportType == .walking ? .circle : .none)
                                    .imageScale(.large)
                            }
                            
                            if let travelTime {
                                let prefix = transportType == .automobile ? "Driving" : "Walking"
                                Text("\(prefix) time: \(travelTime)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .textFieldStyle(.roundedBorder)
                Spacer()
                Button {
                    dismiss()

                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
            }
            if let lookaroundScene {
                LookAroundPreview(initialScene: lookaroundScene)
                    .frame(height: 200)
                    .padding()
            } else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }
            HStack{
                Spacer()
                if let destination {
                    let inList = (selectedPlacemark != nil && selectedPlacemark?.destination != nil)
                    Button {
                        if let selectedPlacemark {
                            if selectedPlacemark.destination == nil {
                                destination.placemarks.append(selectedPlacemark)
                            } else {
                                selectedPlacemark.destination = nil
                            }
                            dismiss()
                        }
                    } label: {
                        Label(inList ? "Remove" : "Add", systemImage: inList ? "minus.circle" : "plus.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(inList ? .red : .green)
                    .disabled((name.isEmpty || isChanged))
                } else {
                    HStack {
                        Button("Open in maps", systemImage: "map") {
                            if let selectedPlacemark {
                                let placemark = MKPlacemark(coordinate: selectedPlacemark.coordinate)
                                let mapItem = MKMapItem(placemark: placemark)
                                mapItem.name = selectedPlacemark.name
                                mapItem.openInMaps()
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        Button("Show Route", systemImage: "location.north") {
                            showRoute.toggle()
                        }
                        .fixedSize(horizontal: true, vertical: false)
                    }
                    .buttonStyle(.bordered)
                }
            }
            Spacer()
        }
        .padding()
        .task(id: selectedPlacemark) {
            await fetchLookAroundPreview()
        }
        .onAppear {
            if let selectedPlacemark,destination != nil {
                name = selectedPlacemark.name
                address = selectedPlacemark.address
            }
        }
    }
    
    func  fetchLookAroundPreview() async {
        if let selectedPlacemark {
            lookaroundScene = nil
            let lookaroundRequest = MKLookAroundSceneRequest(coordinate: selectedPlacemark.coordinate)
            lookaroundScene = try? await lookaroundRequest.scene
        }
    }
}

#Preview ("Destination Tab"){
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<Destination>()
    let destination = try! container.mainContext.fetch(fetchDescriptor)[0]
    let selectedPlacemark = destination.placemarks[0]
    
    return LocationDetailView(
        destination: destination,
        selectedPlacemark: selectedPlacemark,
        showRoute: .constant(false),
        travelInterval: .constant(nil),
        transportType: .constant(.automobile)
    )
}

#Preview ("TripMap Tab"){
    let container = Destination.preview
    let fetchDescriptor = FetchDescriptor<MTPlacemark>()
    let allPlacemarks = try! container.mainContext.fetch(fetchDescriptor)
    let selectedPlacemark = allPlacemarks[0]
    
    return LocationDetailView(
        destination: nil,
        selectedPlacemark: selectedPlacemark,
        showRoute: .constant(false),
        travelInterval: .constant(TimeInterval(1000)),
        transportType: .constant(.automobile)
    )
}
