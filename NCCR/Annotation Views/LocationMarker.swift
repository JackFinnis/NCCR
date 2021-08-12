//
//  LocationMarker.swift
//  LocationMarker
//
//  Created by William Finnis on 10/08/2021.
//

import Foundation
import MapKit

class LocationMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            let colour: UIColor = .brown
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
            
            markerTintColor = colour
            glyphImage = UIImage(systemName: "tram.fill")
            displayPriority = .defaultHigh
            animatesWhenAdded = true
            canShowCallout = true
            clusteringIdentifier = "Cluster"
            
            let routeBtn = UIButton(type: .custom)
            let routeImg = UIImage(systemName: "location.north.circle", withConfiguration: config)
            routeBtn.setImage(routeImg, for: .normal)
            routeBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
            routeBtn.addTarget(self, action: #selector(routeTo), for: .touchUpInside)
            rightCalloutAccessoryView = routeBtn
        }
    }
    
    @objc func routeTo() {
        if let location = annotation as? Location {
            location.mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
        }
    }
}
