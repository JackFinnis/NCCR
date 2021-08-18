//
//  RouteMarker.swift
//  RouteMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class RouteMarker: MKMarkerAnnotationView {
    let vm: ViewModel
    
    override var annotation: MKAnnotation? {
        willSet {
            if let route = newValue as? Route {
                let visited = vm.visitedRoute(id: route.id)
                var colour: UIColor {
                    if visited {
                        return .systemBlue
                    } else {
                        return .systemGreen
                    }
                }
                
                markerTintColor = colour
                glyphText = String(route.id)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
                clusteringIdentifier = "Cluster"
            }
        }
    }
    
    init(vm: ViewModel, annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.vm = vm
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

