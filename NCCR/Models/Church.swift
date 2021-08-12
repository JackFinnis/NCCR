//
//  Church.swift
//  Church
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

class Church: NSObject, MKAnnotation, Decodable, Identifiable {
    let id: Int
    let name: String
    let urlString: String
    let coordinate: CLLocationCoordinate2D
    
    var url: URL { URL(string: urlString)! }
    var title: String? { name }
    var subtitle: String? { "Church " + String(id) }
    
    var coordCLL: CLLocation { CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) }
    
    var mapItem: MKMapItem {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        item.name = name
        return item
    }
}
