//
// Created for MyTrip
// by  Stewart Lynch on 2023-12-23
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI
import MapKit


struct MapStyleView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var mapStyleConfig: MapStyleConfig

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                LabeledContent("Base Style") {
                    Picker("Base Style", selection: $mapStyleConfig.baseStyle) {
                        ForEach(MapStyleConfig.BaseMapStyle.allCases, id: \.self) { type in
                            Text(type.label)
                        }
                    }
                }
                LabeledContent("Elevation") {
                    Picker("Elevation", selection: $mapStyleConfig.elevation) {
                        Text("Flat").tag(MapStyleConfig.MapElevation.flat)
                        Text("Realistic").tag(MapStyleConfig.MapElevation.realistic)
                    }
                }
                if mapStyleConfig.baseStyle != .imagery {
                    LabeledContent("Points of Interest") {
                        Picker("Points of Interest", selection: $mapStyleConfig.pointsOfInterest) {
                            Text("None").tag(MapStyleConfig.MapPOI.excludingAll)
                            Text("All").tag(MapStyleConfig.MapPOI.all)
                        }
                    }
                    
                    Toggle("Show Traffic", isOn: $mapStyleConfig.showTraffic)
                }
                Button("OK") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            .padding()
            .navigationTitle("Map Style")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    MapStyleView(mapStyleConfig: .constant(MapStyleConfig.init()))
}
