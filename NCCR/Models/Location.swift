//
//  Location.swift
//  Location
//
//  Created by William Finnis on 10/08/2021.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    let name: String
    let start: Bool
    let stage: String
    let coordinate: CLLocationCoordinate2D
    
    var title: String? { name }
    var subtitle: String? {
        if start {
            return "Start of " + stage
        } else {
            return "End of " + stage
        }
    }
    
    var mapItem: MKMapItem {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        item.name = name
        return item
    }
    
    init(name: String, start: Bool, stage: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.start = start
        self.stage = stage
        self.coordinate = coordinate
    }
}
