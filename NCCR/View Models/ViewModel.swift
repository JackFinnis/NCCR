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
    // All the routes and churches
    var routes = [Route]()
    var churches = [Church]()
    
    // Filtered Features
    @Published var filteredRoutes = [Route]()
    @Published var filteredChurches = [Church]()
    @Published var filteredPolylines = [Polyline]()
    @Published var loading: LoadingState = .loading
    @Published var selectedRouteNotNil: Route?
    @Published var selectedRoute: Route? { didSet {
        filterFeatures()
        setRegion(routes: [selectedRoute], churches: nil, locations: nil)
        if selectedRoute != nil {
            selectedRouteNotNil = selectedRoute
        }
    }}
    
    // Filters
    @Published var searchText: String = "" { didSet { filterFeatures() } }
    @Published var filter: Bool = false { didSet { filterFeatures() } }
    @Published var showRoutes: Bool = true { didSet { filterFeatures() } }
    @Published var showChurches: Bool = true { didSet { filterFeatures() } }
    @Published var showVisited: Bool = true { didSet { filterFeatures() } }
    @Published var showUnvisited: Bool = true { didSet { filterFeatures() } }
    @Published var minimumDistance: Double = 0 { didSet { filterFeatures() } }
    @Published var maximumDistance: Double = 0 { didSet { filterFeatures() } }
    @Published var maximumProximity: Double = 0 { didSet { filterFeatures() } }
    @Published var sortBy: SortBy = .id { didSet {
        sortRoutes()
        selectFirstRoute()
    }}
    
    // View state
    @Published var animation: Animation? = .none
    @Published var expandAnnotations: Bool = false
    @Published var expandVisited: Bool = false
    @Published var expandDistance: Bool = false
    @Published var expandProximity: Bool = false
    @Published var showSettingsView: Bool = false
    @Published var showShareView: Bool = false
    @Published var showInfoView: Bool = false
    @Published var routesMilestone: Bool = false
    @Published var showMilestoneAlert: Bool = false
    
    // Search bar
    @Published var showCancelButton: Bool = false
    var searchBarshowCancelButton: Bool = false
    
    // Map
    @Published var mapType: MKMapType = .standard
    @Published var trackingMode: MKUserTrackingMode = .none
    @Published var regionToZoom = MKCoordinateRegion()
    @Published var updateZoomLevel: Bool = true
    var mapUpdateZoomLevel: Bool = true
    
    var userLocation = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    var mapSelectedRoute: Route?
    
    // Core Data
    var persistenceManager = PersistenceManager()
    var visitedFeatures: VisitedFeatures!
    var settings: Settings!
    @Published var distanceUnit: DistanceUnit = .metric { didSet {
        toggleDistanceUnit()
    }}
    
    // Constants
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
    public func loadRoutes() {
        let url = URL(string: "https://nccr-api.finnisjack.repl.co/routes")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Route].self, from: data) {
                    DispatchQueue.main.async {
                        self.routes = response
                        self.extractAllChurches()
                        self.filterFeatures()
                        self.loading = .loaded
                        self.setRegion(routes: response, churches: nil, locations: nil)
                    }
                    return
                }
            }
            print("\(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
                self.loading = .error
            }
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
            let visitedFeaturesArray: [VisitedFeatures] = try context.fetch(VisitedFeatures.fetchRequest())
            
            if visitedFeaturesArray.isEmpty {
                visitedFeatures = VisitedFeatures(context: context)
                visitedFeatures.routes = []
                visitedFeatures.churches = []
                self.objectWillChange.send()
                
                persistenceManager.save()
            } else {
                visitedFeatures = visitedFeaturesArray.first!
                self.objectWillChange.send()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchSettings() {
        do {
            let context = persistenceManager.container.viewContext
            let settingsArray: [Settings] = try context.fetch(Settings.fetchRequest())
            
            if settingsArray.isEmpty {
                settings = Settings(context: context)
                settings.metric = true
                persistenceManager.save()
            } else {
                settings = settingsArray.first!
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
        filterRoutes()
        filterChurches()
        searchChurches()
        searchRoutes()
        sortRoutes()
        filterPolylines()
        updateSelectedRoute()
    }
    
    // Filter routes
    private func filterRoutes() {
        filteredRoutes = routes.filter { route in
            if filter {
                if !showRoutes { return false }
                if visitedRoute(id: route.id) && !showVisited { return false }
                if !visitedRoute(id: route.id) && !showUnvisited { return false }
                if minimumDistance > maximumDistance && route.metres < Int(minimumDistance) { return false }
                if minimumDistance < maximumDistance && (route.metres > Int(maximumDistance) || route.metres < Int(minimumDistance)) { return false }
                if maximumProximity != 0 && distanceTo(route: route) > maximumProximity { return false }
            }
            return true
        }
    }
    
    // Filter churches
    private func filterChurches() {
        var filteredRoutesChurches = [Church]()
        if filter && !showRoutes {
            filteredRoutesChurches = churches
        } else {
            for route in filteredRoutes {
                filteredRoutesChurches.append(contentsOf: route.churches)
            }
        }
        
        if filter {
            filteredChurches = filteredRoutesChurches.filter { church in
                if !showChurches { return false }
                if visitedChurch(id: church.id) && !showVisited { return false }
                if !visitedChurch(id: church.id) && !showUnvisited { return false }
                return true
            }
        } else {
            filteredChurches = filteredRoutesChurches
        }
    }
    
    // Filter churches by search Text
    private func searchChurches() {
        filteredChurches = filteredChurches.filter { church in
            if selectedRoute != nil && selectedRoute!.churches.contains(church) { return true }
            if selectedRoute == nil && !searchText.isEmpty && church.name.localizedCaseInsensitiveContains(searchText) { return true }
            if selectedRoute == nil && searchText.isEmpty && filter && !showRoutes { return true }
            return false
        }
    }
    
    // Filter routes by search text
    private func searchRoutes() {
        filteredRoutes = filteredRoutes.filter { route in
            if searchText.isEmpty { return true }
            if route.start.localizedCaseInsensitiveContains(searchText) { return true }
            if route.end.localizedCaseInsensitiveContains(searchText) { return true }
            for church in route.churches {
                if filteredChurches.contains(church) { return true }
            }
            return false
        }
    }
    
    // Sort routes
    private func sortRoutes() {
        filteredRoutes = filteredRoutes.sorted { (route1, route2) in
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
        if let index = indexOfRoute(id: route.id) {
            unvisitRoute(route: route, index: index)
        } else {
            visitRoute(route: route)
        }
    }
    
    func unvisitRoute(route: Route, index: Int) {
        visitedFeatures.routes!.remove(at: index)
        for church in route.churches {
            if let index = indexOfChurch(id: church.id) {
                visitedFeatures.churches!.remove(at: index)
            }
        }
        filterFeatures()
        persistenceManager.save()
    }
    
    func visitRoute(route: Route) {
        visitedFeatures.routes!.append(route.id)
        checkForRouteMilestone()
        for church in route.churches {
            if !visitedChurch(id: church.id) {
                visitChurch(id: church.id)
            }
        }
        filterFeatures()
        persistenceManager.save()
    }
    
    // Toggle whether given church has been visited
    func toggleVisitedChurch(id: Int) {
        if let index = visitedFeatures.churches!.firstIndex(of: id) {
            unvisitChurch(index: index)
        } else {
            visitChurch(id: id)
        }
    }
    
    func unvisitChurch(index: Int) {
        visitedFeatures.churches!.remove(at: index)
        filterFeatures()
        persistenceManager.save()
    }
    
    func visitChurch(id: Int) {
        visitedFeatures.churches!.append(id)
        checkForChurchMilestone()
        filterFeatures()
        persistenceManager.save()
    }
    
    func checkForRouteMilestone() {
        if visitedFeatures.routes!.count % 5 == 0 || visitedFeatures.routes!.count == 26 {
            DispatchQueue.main.async {
                self.routesMilestone = true
                self.showMilestoneAlert = true
            }
        }
    }
    
    func checkForChurchMilestone() {
        if visitedFeatures.churches!.count % 100 == 0 || visitedFeatures.churches!.count == 632 {
            DispatchQueue.main.async {
                self.routesMilestone = false
                self.showMilestoneAlert = true
            }
        }
    }
    
    // Check whether given church has been visited
    func indexOfRoute(id: Int) -> Int? {
        visitedFeatures.routes!.firstIndex(of: id)
    }
    
    // Check whether given church has been visited
    func indexOfChurch(id: Int) -> Int? {
        visitedFeatures.churches!.firstIndex(of: id)
    }
    
    func visitedRoute(id: Int) -> Bool {
        if indexOfRoute(id: id) == nil {
            return false
        } else {
            return true
        }
    }
    
    func visitedChurch(id: Int) -> Bool {
        if indexOfChurch(id: id) == nil {
            return false
        } else {
            return true
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
    
    func getVisitedRoutesSummary() -> String {
        if visitedFeatures.routes!.count == 26 {
            return "You have cycled all 26 routes!"
        } else {
            return "\(visitedFeatures.routes!.count)/26 routes cycled"
        }
    }
    
    // Get proportion of total distance cycled
    func getDistanceCycledSummary() -> String {
        if visitedFeatures.routes!.count == 26 {
            return "You have cycled \(getFormattedDistanceWithUnit(metres: totalMetres))!"
        } else {
            var metres: Int = 0
            for route in routes {
                if visitedFeatures.routes!.contains(route.id) {
                    metres += route.metres
                }
            }
            
            let formattedDistanceTravelled = getFormattedDistanceWithoutUnit(metres: metres)
            let formattedTotalDistanceWithUnit = getFormattedDistanceWithUnit(metres: totalMetres)
            
            return formattedDistanceTravelled + "/" + formattedTotalDistanceWithUnit + " cycled"
        }
    }
    
    func getVisitedChurchesSummary() -> String {
        if visitedFeatures.churches!.count == 632 {
            return "You have visited every medieval church in Norfolk!"
        } else {
            return "\(visitedFeatures.churches!.count)/632 churches visited"
        }
    }
    
    func getMilestoneSummary() -> String {
        if routesMilestone {
            return getVisitedRoutesSummary()
        } else {
            return getVisitedChurchesSummary()
        }
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
    
    // Get formatted distance from distance in unit Int
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
    
    func getFormattedDistanceWithoutUnit(metres: Int) -> String {
        let distance = Int(getDistance(metres: metres))
        return getFormattedDistance(distance: distance)
    }
    
    // Convert metres to km or miles appropriately
    func getDistance(metres: Int) -> Double {
        if distanceUnit == .metric {
            return Double(metres) / 1_000
        } else {
            return Double(metres) / 1_609.34
        }
    }
    
    // Add the preferred unit to the given distance string
    func addUnit(distance: String) -> String {
        if distanceUnit == .metric {
            return distance + " km"
        } else {
            return distance + " miles"
        }
    }
    
    // Get formatted total distance
    func getFormattedDistanceWithUnit(metres: Int) -> String {
        let totalDistance = Int(getDistance(metres: metres))
        let formattedTotalDistance = getFormattedDistance(distance: totalDistance)
        return addUnit(distance: formattedTotalDistance)
    }
    
    // Get the formatted density of the given route
    func getFormattedDensity(route: Route) -> String {
        let density = getDistance(metres: route.metres) / Double(route.churches.count)
        let formattedDensity = addUnit(distance: String(format: "%.1f", density))
        return formattedDensity + "/Church"
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
    public func setRegion(routes: [Route?]?, churches: [Church]?, locations: [Location]?) {
        var coords = [CLLocationCoordinate2D]()
        var regionHasRoutes: Bool = false
        
        if routes != nil && !routes!.isEmpty {
            regionHasRoutes = true
            var routesToZoomTo = routes!
            if routes!.first! == nil {
                routesToZoomTo = filteredRoutes
            }
            
            for route in routesToZoomTo {
                coords.append(route!.coords.first!)
                coords.append(route!.coords.last!)
                for church in route!.churches {
                    coords.append(church.coordinate)
                }
            }
        }
        if churches != nil {
            for church in churches! {
                coords.append(church.coordinate)
            }
        }
        if locations != nil {
            for location in locations! {
                coords.append(location.coordinate)
            }
        }
        
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLong: Double = 180
        var maxLong: Double = -180
        
        if coords.count < 2 {
            return
        }
        
        for coord in coords {
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
        
        let latBounds = 1.4
        var longBounds = 2.0
        if regionHasRoutes {
            longBounds = 1.1
        }
        
        
        let latDelta: Double = maxLat - minLat
        let longDelta: Double = maxLong - minLong
        let span = MKCoordinateSpan(latitudeDelta: latDelta * latBounds, longitudeDelta: longDelta * longBounds)
        let centre = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2)
        let region = MKCoordinateRegion(center: centre, span: span)
        
        regionToZoom = region
        updateZoomLevel.toggle()
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
        let formattedMaximumProximity = getFormattedDistanceWithUnit(metres: Int(maximumProximity))
        
        if maximumProximity == 0 {
            return "No Filter"
        } else {
            return "< " + formattedMaximumProximity + " away"
        }
    }
    
    // Distance summary
    public var filterDistanceSummary: String {
        let formattedMinimumDistance = getFormattedDistanceWithUnit(metres: Int(minimumDistance))
        let formattedMaximumDistance = getFormattedDistanceWithUnit(metres: Int(maximumDistance))
        
        if minimumDistance == 0 && maximumDistance == 0 {
            return "No Filter"
        } else if minimumDistance >= maximumDistance {
            return "> " + formattedMinimumDistance
        } else if minimumDistance == 0 {
            return "< " + formattedMaximumDistance
        } else {
            return getFormattedDistanceWithoutUnit(metres: Int(minimumDistance)) + "-" + formattedMaximumDistance
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
    
    public var showSettingsImage: String {
        if showSettingsView {
            return "gearshape.fill"
        } else {
            return "gearshape"
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
        
        let routeId = polyline.route!.id
        var colour: UIColor {
            if visitedRoute(id: routeId) {
                return .systemBlue
            }
            
            switch routeId % 7 {
            case 6:
                return .systemOrange
            case 5:
                return .systemYellow
            case 4:
                return .systemGreen
            case 3:
                return .systemTeal
            case 2:
                return .systemPurple
            case 1:
                return .systemIndigo
            default:
                return .systemPink
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
    
    func mapView(_ mapView: MKMapView, didSelect: MKAnnotationView) {
        if let routeMarker = didSelect as? RouteMarker {
            if let route = routeMarker.annotation as? Route {
                selectedRoute = route
            }
//        } else if let churchMarker = didSelect as? ChurchMarker {
//            if let church = churchMarker.annotation as? Church {
//                UIApplication.shared.open(church.url)
//            }
        } else if let locationMarker = didSelect as? LocationMarker {
            if let location = locationMarker.annotation as? Location {
                location.mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
            }
        } else if let clusterMarker = didSelect as? ClusterMarker {
            if let cluster = clusterMarker.annotation as? MKClusterAnnotation {
                var routes = [Route]()
                var churches = [Church]()
                var locations = [Location]()
                for annotation in cluster.memberAnnotations {
                    if let route = annotation as? Route {
                        routes.append(route)
                    } else if let church = annotation as? Church {
                        churches.append(church)
                    } else if let location = annotation as? Location {
                        locations.append(location)
                    }
                }
                setRegion(routes: routes, churches: churches, locations: locations)
            }
        }
    }
}

extension ViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        self.searchText = textDidChange
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarshowCancelButton = true
        showCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if filteredRoutes.count == 1 {
            selectedRoute = filteredRoutes.first
        } else {
            setRegion(routes: filteredRoutes, churches: nil, locations: nil)
        }
    }
}
