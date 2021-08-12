//
//  ChurchMarker.swift
//  ChurchMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class ChurchMarker: MKMarkerAnnotationView {
    let vm: ViewModel
    
    override var annotation: MKAnnotation? {
        willSet {
            if let church = annotation as? Church {
                let visited = vm.visitedChurch(id: church.id)
                var colour: UIColor {
                    if visited {
                        return .systemPink
                    } else {
                        return .systemGreen
                    }
                }
                
                markerTintColor = colour
                glyphImage = UIImage(named: "cross")
                displayPriority = .defaultHigh
                animatesWhenAdded = true
                canShowCallout = true
                clusteringIdentifier = "Cluster"
                
                let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
                
                let visitedBtn = UIButton(type: .custom)
                let visitedImg = UIImage(systemName: vm.visitedChurchImage(id: church.id), withConfiguration: config)
                visitedBtn.setImage(visitedImg, for: .normal)
                if visited { visitedBtn.tintColor = colour }
                visitedBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                visitedBtn.addTarget(self, action: #selector(toggleVisitedChurch), for: .touchUpInside)
                leftCalloutAccessoryView = visitedBtn
                
                let infoBtn = UIButton(type: .custom)
                let infoImg = UIImage(systemName: "info.circle", withConfiguration: config)
                infoBtn.setImage(infoImg, for: .normal)
                if visited { infoBtn.tintColor = colour }
                infoBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                infoBtn.addTarget(self, action: #selector(openChurchUrl), for: .touchUpInside)
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
    
    @objc func toggleVisitedChurch() {
        if let church = annotation as? Church {
            vm.toggleVisitedChurch(id: church.id)
        }
    }
    
    @objc func openChurchUrl() {
        if let church = annotation as? Church {
            UIApplication.shared.open(church.url)
        }
    }
}
