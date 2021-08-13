//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var vm: ViewModel
    
    func makeCoordinator() -> ViewModel {
        return vm
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        // Set delegate
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = false
        mapView.showsCompass = true
        mapView.isPitchEnabled = false
        
        // Register annotations
        mapView.register(ChurchMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(RouteMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(LocationMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Pan to all routes
        if vm.mapUpdateZoomLevel != vm.updateZoomLevel {
            vm.mapUpdateZoomLevel = vm.updateZoomLevel
            mapView.setRegion(vm.regionToZoom, animated: true)
        }
        
        // Pan to route
        if vm.mapSelectedRoute != vm.selectedRoute {
            vm.mapSelectedRoute = vm.selectedRoute
            mapView.setRegion(vm.regionToZoom, animated: true)
        }
        
        // Set user tracking mode
        if mapView.userTrackingMode != vm.trackingMode {
            mapView.setUserTrackingMode(vm.trackingMode, animated: true)
        }
        
        // Set map type
        if mapView.mapType != vm.mapType {
            mapView.mapType = vm.mapType
        }
        
        // Update annotations and overlays
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        if vm.loading == .loaded {
            if vm.selectedRoute != nil {
                mapView.addAnnotations(vm.filteredChurches)
                mapView.addOverlay(vm.selectedRoute!.polyline)
                if vm.searchText.isEmpty {
                    mapView.addAnnotations(vm.selectedRoute!.locations)
                }
            } else {
                mapView.addAnnotations(vm.filteredChurches)
                mapView.addAnnotations(vm.filteredRoutes)
                mapView.addOverlays(vm.filteredPolylines)
            }
        }
    }
}
