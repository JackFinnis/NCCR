//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit
import SwiftUI

class ViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    // Routes and churches
    var routes = [Route]()
    var churches = [Church]()
    
    // Filtered features
    @Published var filteredRoutes = [Route]()
    @Published var filteredChurches = [Church]()
    @Published var filteredPolylines = [Polyline]()
    @Published var selectedRoute: Route? { didSet { filterFeatures() } }
    
    // Filters
    @Published var searchText: String = "" { didSet { filterFeatures() } }
    @Published var filter: Bool = false { didSet { filterFeatures() } }
    @Published var showRoutes: Bool = true { didSet { filterFeatures() } }
    @Published var showChurches: Bool = true { didSet { filterFeatures() } }
    @Published var showVisited: Bool = true { didSet { filterFeatures() } }
    @Published var showUnvisited: Bool = true { didSet { filterFeatures() } }

    @Published var showTrains: Bool = true { didSet { filterFeatures() } }
    
    @Published var minimumDistance: Double = 0 { didSet { filterFeatures() } }
    @Published var maximumDistance: Double = 0 { didSet { filterFeatures() } }
    @Published var maximumProximity: Double = 0 { didSet { filterFeatures() } }
    @Published var sortBy: SortBy = .id { didSet {
        filterFeatures()
        selectFirstRoute()
    }}
    
    // View state
    @Published var loading: Bool = true
    @Published var zoomOut: Bool = false
    @Published var animation: Animation? = .none
    @Published var showSearchBar: Bool = false
    @Published var expandAnnotations: Bool = false
    @Published var expandVisited: Bool = false
    @Published var expandDistance: Bool = false
    @Published var expandProximity: Bool = false
    @Published var showFilterView: Bool = false
    @Published var showShareView: Bool = false
    @Published var showInfoView: Bool = false
    
    // Map settings
    @Published var mapType: MKMapType = .standard
    @Published var trackingMode: MKUserTrackingMode = .none
    var userLocation = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    
    // Map history variables
    var mapSelectedRoute: Route?
    var mapZoomOut: Bool = false
    
    // Core Data
    var persistenceManager = PersistenceManager()
    var visitedFeatures: VisitedFeatures!
    var settings: Settings!
    @Published var distanceUnit: DistanceUnit = .metric { didSet {
        toggleDistanceUnit()
    }}
    
    // Totals
    let totalMetres = 2_115_747
    
    // MARK: - Initialiser
    override init() {
        super.init()
        setupLocationManager()
        fetchVisited()
        fetchSettings()
        loadRoutes()
    }
    
    // Setup location manager
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    // Load routes from the api
    private func loadRoutes() {
        let url = URL(string: "https://ncct.finnisjack.repl.co/routes")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Route].self, from: data) {
                    DispatchQueue.main.async {
                        self.routes = response
                        self.extractAllChurches()
                        self.filterFeatures()
                        self.loading = false
                        self.zoomOut.toggle()
                    }
                    return
                }
            }
            print("\(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    // Get array of all churches
    private func extractAllChurches() {
        var allChurches = [Church]()
        for route in routes {
            allChurches.append(contentsOf: route.churches)
        }
        churches = allChurches
    }
    
    private func fetchVisited() {
        do {
            let context = persistenceManager.container.viewContext
            let visitedFeaturesArray = try context.fetch(VisitedFeatures.fetchRequest())
            
            if visitedFeaturesArray.isEmpty {
                visitedFeatures = VisitedFeatures(context: context)
                visitedFeatures.routes = []
                visitedFeatures.churches = []
                self.objectWillChange.send()
                
                persistenceManager.save()
            } else {
                visitedFeatures = visitedFeaturesArray.first! as? VisitedFeatures
                self.objectWillChange.send()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchSettings() {
        do {
            let context = persistenceManager.container.viewContext
            let settingsArray = try context.fetch(Settings.fetchRequest())
            
            if settingsArray.isEmpty {
                settings = Settings(context: context)
                settings.metric = true
                persistenceManager.save()
            } else {
                settings = settingsArray.first! as? Settings
            }
            
            if settings.metric {
                distanceUnit = .metric
            } else {
                distanceUnit = .imperial
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Filter Routes
    // Filter map features
    private func filterFeatures() {
        filterChurches()
        filterRoutes()
        filterPolylines()
        updateSelectedRoute()
    }
    
    // Filter churches
    private func filterChurches() {
        if filter && !showChurches || (selectedRoute == nil && searchText.isEmpty) {
            filteredChurches = []
            return
        }
        
        var churchesToFilter = [Church]()
        if selectedRoute != nil {
            churchesToFilter = selectedRoute!.churches
        } else {
            churchesToFilter = churches
        }
        
        filteredChurches = churchesToFilter.filter { church in
            if visitedChurch(id: church.id) && !showVisited { return false }
            if !visitedChurch(id: church.id) && !showUnvisited { return false }
            if searchText.isEmpty { return true }
            if church.name.localizedCaseInsensitiveContains(searchText) { return true }
            return false
        }
    }
    
    // Filter routes
    private func filterRoutes() {
        filteredRoutes = routes.filter { route in
            if filter {
                if !showRoutes { return false }
                if visitedRoute(id: route.id) && !showVisited { return false }
                if !visitedRoute(id: route.id) && !showUnvisited { return false }
                if minimumDistance > maximumDistance && route.metres < Int(minimumDistance) * 1_000 { return false }
                if minimumDistance < maximumDistance && (route.metres > Int(maximumDistance) * 1_000 || route.metres < Int(minimumDistance) * 1_000) { return false }
                if maximumProximity != 0 && distanceTo(route: route) > maximumProximity { return false }
            }
            if searchText.isEmpty { return true }
            if route.start.localizedCaseInsensitiveContains(searchText) { return true }
            if route.end.localizedCaseInsensitiveContains(searchText) { return true }
            for church in route.churches {
                if filteredChurches.contains(church) { return true }
            }
            return false
        }
        .sorted { (route1, route2) in
            switch sortBy {
            case .id:
                return route1.id < route2.id
            case .distance:
                return route1.metres > route2.metres
            case .churchDensity:
                return route1.density < route2.density
            case .closest:
                return distanceTo(route: route1) < distanceTo(route: route2)
            }
        }
    }
    
    // Filter polylines
    private func filterPolylines() {
        var polylines = [Polyline]()
        for route in filteredRoutes {
            polylines.append(route.polyline)
        }
        filteredPolylines = polylines
    }
    
    // MARK: - Visited Features
    // Toggle whether given route has been visited
    func toggleVisitedRoute(route: Route) {
        if let index = visitedFeatures.routes!.firstIndex(of: route.id) {
            visitedFeatures.routes!.remove(at: index)
            for church in route.churches {
                if let index = visitedFeatures.churches!.firstIndex(of: church.id) {
                    visitedFeatures.churches!.remove(at: index)
                }
            }
        } else {
            visitedFeatures.routes!.append(route.id)
            for church in route.churches {
                if !visitedFeatures.churches!.contains(church.id) {
                    visitedFeatures.churches!.append(church.id)
                }
            }
        }
        self.objectWillChange.send()
        persistenceManager.save()
    }
    
    // Toggle whether given church has been visited
    func toggleVisitedChurch(id: Int) {
        if let index = visitedFeatures.churches!.firstIndex(of: id) {
            visitedFeatures.churches!.remove(at: index)
        } else {
            visitedFeatures.churches!.append(id)
        }
        self.objectWillChange.send()
        persistenceManager.save()
    }
    
    // Check whether given church has been visited
    func visitedRoute(id: Int) -> Bool {
        if visitedFeatures.routes!.contains(id) {
            return true
        } else {
            return false
        }
    }
    
    // Check whether given church has been visited
    func visitedChurch(id: Int) -> Bool {
        if visitedFeatures.churches!.contains(id) {
            return true
        } else {
            return false
        }
    }
    
    // Check whether given church has been visited and return appropriate image
    func visitedRouteImage(id: Int) -> String {
        if visitedRoute(id: id) {
            return "checkmark.circle.fill"
        } else {
            return "checkmark.circle"
        }
    }
    
    // Check whether given church has been visited and return appropriate image
    func visitedChurchImage(id: Int) -> String {
        if visitedChurch(id: id) {
            return "checkmark.circle.fill"
        } else {
            return "checkmark.circle"
        }
    }
    
    // Get formatted
    
    // Get proportion of total distance cycled
    func getDistanceCycledSummary() -> String {
        var metres: Int = 0
        for route in routes {
            if visitedFeatures.routes!.contains(route.id) {
                metres += route.metres
            }
        }
        
        let distanceTravelled = getDistance(metres: metres)
        let formattedDistanceTravelled = getFormattedDistance(distance: distanceTravelled)
        
        let totalDistance = getDistance(metres: totalMetres)
        let formattedTotalDistance = getFormattedDistance(distance: totalDistance)
        let formattedTotalDistanceWithUnit = addUnit(distance: formattedTotalDistance)
        
        return formattedDistanceTravelled + "/" + formattedTotalDistanceWithUnit
    }
    
    // MARK: - Settings
    // Toggle the distance unit saved in core data
    func toggleDistanceUnit() {
        if distanceUnit == .metric {
            settings.metric = true
        } else {
            settings.metric = false
        }
        persistenceManager.save()
    }
    
    func getFormattedDistance(distance: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let distanceString = formatter.string(from: NSNumber(value: distance))
        
        if distanceString == nil {
            return "0"
        } else {
            return distanceString!
        }
    }
    
    // Convert metres to km or miles appropriately
    func getDistance(metres: Int) -> Int {
        if distanceUnit == .metric {
            return metres / 1_000
        } else {
            return Int(Double(metres) / 1_609.34)
        }
    }
    
    func addUnit(distance: String) -> String {
        if distanceUnit == .metric {
            return distance + " km"
        } else {
            return distance + " miles"
        }
    }
    
    // MARK: - Selected Route
    // Update selected route when new filter imposed
    public func updateSelectedRoute() {
        if getSelectedRouteIndex() == nil && selectedRoute != nil {
            selectedRoute = nil
        }
    }
    
    // Select first route
    public func selectFirstRoute() {
        selectedRoute = filteredRoutes.first
    }
    
    // Select next route
    public func nextRoute() {
        let index = getSelectedRouteIndex()
        if index != nil {
            if index! == filteredRoutes.count-1 {
                selectedRoute = filteredRoutes.first
            } else {
                selectedRoute = filteredRoutes[index!+1]
            }
        }
    }
    
    // Select previous route
    public func previousRoute() {
        let index = getSelectedRouteIndex()
        if index != nil {
            if index! == 0 {
                selectedRoute = filteredRoutes.last
            } else {
                selectedRoute = filteredRoutes[index!-1]
            }
        } else if filteredRoutes.isEmpty {
            selectedRoute = nil
        } else {
            selectedRoute = filteredRoutes.first
        }
    }
    
    // Get the index of the current selected route
    private func getSelectedRouteIndex() -> Int? {
        if filteredRoutes.isEmpty {
            return nil
        } else if selectedRoute == nil {
            return nil
        } else {
            let index = filteredRoutes.firstIndex(of: selectedRoute!)
            if index == nil {
                return nil
            } else {
                return index
            }
        }
    }
    
    // MARK: - Map Helper Functions
    // Get map region
    public func getRoutesRegion(all: Bool) -> MKCoordinateRegion? {
        var routes = [Route]()
        if all {
            routes = filteredRoutes
        } else if selectedRoute != nil {
            routes = [selectedRoute!]
        } else {
            return nil
        }
        
        guard !routes.isEmpty else {
            return nil
        }
        
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLong: Double = 180
        var maxLong: Double = -180
        
        for route in routes {
            for coord in route.coords {
                if coord.latitude < minLat {
                    minLat = coord.latitude
                }
                if coord.latitude > maxLat {
                    maxLat = coord.latitude
                }
                if coord.longitude < minLong {
                    minLong = coord.longitude
                }
                if coord.longitude > maxLong {
                    maxLong = coord.longitude
                }
            }
        }
        
        let latDelta: Double = maxLat - minLat
        let longDelta: Double = maxLong - minLong
        let span = MKCoordinateSpan(latitudeDelta: latDelta * 1.4, longitudeDelta: longDelta * 1.4)
        let centre = CLLocationCoordinate2D(latitude: (minLat + maxLat) * 0.5/*0.49963*/, longitude: (minLong + maxLong) * 0.5)
        let region = MKCoordinateRegion(center: centre, span: span)
        return region
    }
    
    // Get the distance between the user and route
    private func distanceTo(route: Route) -> Double {
        var minimum: Double = .greatestFiniteMagnitude
        var delta: Double = 0
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        delta = userCLLocation.distance(from: route.startCLL)
        if minimum > delta { minimum = delta }
        
        delta = userCLLocation.distance(from: route.endCLL)
        if minimum > delta { minimum = delta }
        
        for church in route.churches {
            delta = userCLLocation.distance(from: church.coordCLL)
            if minimum > delta { minimum = delta }
        }
        
        return minimum
    }
    
    // MARK: - Filter Summaries
    // Annotation summary
    public var filterAnnotationsSummary: String {
        if showRoutes && showChurches {
            return "No Filter"
        } else if showRoutes {
            return "Routes"
        } else if showChurches {
            return "Churches"
        } else {
            return "No Features"
        }
    }
    
    // Visited summary
    public var filterVisitedSummary: String {
        if showVisited && showUnvisited {
            return "No Filter"
        } else if showVisited {
            return "Visited"
        } else if showUnvisited {
            return "Unvisited"
        } else {
            return "No Features"
        }
    }
    
    // Separation summary
    public var filterProximitySummary: String {
        if maximumProximity == 0 {
            return "No Filter"
        } else {
            return "< \(Int(maximumProximity)) km away"
        }
    }
    
    // Distance summary
    public var filterDistanceSummary: String {
        if minimumDistance == 0 && maximumDistance == 0 {
            return "No Filter"
        } else if minimumDistance >= maximumDistance {
            return "> \(Int(minimumDistance)) km"
        } else if minimumDistance == 0 {
            return "< \(Int(maximumDistance)) km"
        } else {
            return "\(Int(minimumDistance))-\(Int(maximumDistance)) km"
        }
    }
    
    // MARK: - Images Names
    // Display image names
    public var trackingModeImage: String {
        switch trackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    public var mapTypeImage: String {
        switch mapType {
        case .standard:
            return "globe"
        default:
            return "map"
        }
    }
    
    public var showSearchBarImage: String {
        if showSearchBar {
            return "minus.magnifyingglass"
        } else {
            return "plus.magnifyingglass"
        }
    }
    
    public var filterImage: String {
        if filter {
            return "line.horizontal.3.decrease.circle.fill"
        } else {
            return "line.horizontal.3.decrease.circle"
        }
    }
    
    public var showInfoImage: String {
        if showInfoView {
            return "info.circle.fill"
        } else {
            return "info.circle"
        }
    }
    
    // MARK: - Update Functions
    // User tracking mode button pressed
    public func updateTrackingMode() {
        switch trackingMode {
        case .none:
            trackingMode = .follow
        case .follow:
            trackingMode = .followWithHeading
        default:
            trackingMode = .none
        }
    }
    
    // Map type button pressed
    public func updateMapType() {
        switch mapType {
        case .standard:
            mapType = .hybrid
        default:
            mapType = .standard
        }
    }
}

// MARK: - CLLocationManager Delegate
extension ViewModel: CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.coordinate
    }
}

// MARK: - MKMapView Delegate
extension ViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? Polyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        var colour: UIColor {
            if visitedRoute(id: polyline.route!.id) {
                return .systemPink
            } else {
                return .systemBlue
            }
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = colour
        renderer.lineWidth = 2
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is Church:
            return ChurchMarker(vm: self, annotation: annotation, reuseIdentifier: "Church")
        case is Route:
            return RouteMarker(vm: self, annotation: annotation, reuseIdentifier: "Route")
        case is Location:
            return LocationMarker(annotation: annotation, reuseIdentifier: "Location")
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if !animated {
            trackingMode = .none
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if animation != .default {
            animation = .default
        }
    }
}
