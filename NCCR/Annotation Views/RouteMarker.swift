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
                        return .systemPink
                    } else {
                        return .systemBlue
                    }
                }
                
                markerTintColor = colour
                glyphText = String(route.id)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                clusteringIdentifier = "Cluster"
                
                let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
                
                let visitedBtn = UIButton(type: .custom)
                let visitedImg = UIImage(systemName: vm.visitedRouteImage(id: route.id), withConfiguration: config)
                visitedBtn.setImage(visitedImg, for: .normal)
                if visited { visitedBtn.tintColor = colour }
                visitedBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                visitedBtn.addTarget(self, action: #selector(toggleVisitedRoute), for: .touchUpInside)
                leftCalloutAccessoryView = visitedBtn
                
                let infoBtn = UIButton(type: .custom)
                let infoImg = UIImage(systemName: "info.circle", withConfiguration: config)
                infoBtn.setImage(infoImg, for: .normal)
                if visited { infoBtn.tintColor = colour }
                infoBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                infoBtn.addTarget(self, action: #selector(selectRoute), for: .touchUpInside)
                rightCalloutAccessoryView = infoBtn
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
    
    @objc func toggleVisitedRoute() {
        if let route = annotation as? Route {
            vm.toggleVisitedRoute(route: route)
        }
    }
    
    @objc func selectRoute() {
        if let route = annotation as? Route {
            vm.selectedRoute = route
        }
    }
}

