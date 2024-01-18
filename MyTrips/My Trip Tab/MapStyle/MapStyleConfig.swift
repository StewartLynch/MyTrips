//
// Created for MyTrips
// by  Stewart Lynch on 2024-01-17
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI
import MapKit

struct MapStyleConfig {
    enum BaseMapStyle: CaseIterable {
        case standard, hybrid, imagery
        var label: String {
            switch self {
            case .standard:
                "Standard"
            case .hybrid:
                "Satellite with roads"
            case .imagery:
                "Satellite only"
            }
        }
    }
    
    enum MapElevation {
        case flat, realistic
        var selection: MapStyle.Elevation {
            switch self {
            case .flat:
                    .flat
            case .realistic:
                    .realistic
            }
        }
    }
    
    enum MapPOI {
        case all, excludingAll
        var selection: PointOfInterestCategories {
            switch self {
            case .all:
                    .all
            case .excludingAll:
                    .excludingAll
            }
        }
    }
    
    var baseStyle = BaseMapStyle.standard
    var elevation = MapElevation.flat
    var pointsOfInterest = MapPOI.excludingAll
    
    var showTraffic = false
    
    var mapStyle: MapStyle {
        switch baseStyle {
        case .standard:
            MapStyle.standard(elevation: elevation.selection, pointsOfInterest: pointsOfInterest.selection, showsTraffic: showTraffic)
        case .hybrid:
            MapStyle.hybrid(elevation: elevation.selection, pointsOfInterest: pointsOfInterest.selection, showsTraffic: showTraffic)
        case .imagery:
            MapStyle.imagery(elevation: elevation.selection)
        }
    }
}
