//
//  Route.swift
//  Route
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit
import UIKit

class Route: NSObject, MKAnnotation, Decodable, Identifiable {
    let id: Int
    let start: String
    let end: String
    let metres: Int
    let churches: [Church]
    let coords: [CLLocationCoordinate2D]
    
    var stage: String { "Route \(id)" }
    var name: String { start + " to " + end }
    var density: Double { Double(metres) / Double(churches.count) / 1_000 }
    var polyline: Polyline {
        let polyline = Polyline(coordinates: coords, count: coords.count)
        polyline.route = self
        return polyline
    }
    
    var title: String? { name }
    var subtitle: String? { stage }
    var coordinate: CLLocationCoordinate2D { coords[coords.count / 2] }
    
    var startCLL: CLLocation { CLLocation(latitude: coords.first!.latitude, longitude: coords.first!.longitude) }
    var endCLL: CLLocation { CLLocation(latitude: coords.last!.latitude, longitude: coords.last!.longitude) }
    
    var locations: [Location] {[
        Location(name: start, start: true, stage: stage, coordinate: coords.first!),
        Location(name: end, start: false, stage: stage, coordinate: coords.last!)
    ]}
}
