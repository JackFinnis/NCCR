//
//  ClusterMarker.swift
//  ClusterMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class ClusterMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let colour: UIColor = .systemOrange
                
                markerTintColor = colour
                glyphText = String(cluster.memberAnnotations.count)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
            }
        }
    }
}
