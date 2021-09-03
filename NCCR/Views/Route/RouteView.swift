//
//  RouteView.swift
//  NCCR
//
//  Created by Jack Finnis on 30/08/2021.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var vm: ViewModel
    
    let route: Route
    let email: String = "contact.nccr@gmail.com"
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                if route.routeTitle != nil {
                    Text(route.routeTitle!)
                        .font(.headline)
                }
                Row(leading: "Distance", trailing: vm.getFormattedDistanceWithUnit(metres: route.metres))
                Row(leading: "Churches", trailing: String(route.churches.count))
                Row(leading: "Church Density", trailing: vm.getFormattedDensity(route: route))
                if route.routeDescription != nil {
                    Text(route.routeDescription!)
                }
            }
            
            Section(header: Text("Directions"), footer: Text(route.directionsAuthor == nil ? "" : "Directions by " + route.directionsAuthor!)) {
                LocationRow(type: "Start", name: route.start, mapItem: route.locations[0].mapItem)
                
                if route.directions == nil {
                    List(0..<route.churches.count) { i in
                        ChurchRow(i: i, church: route.churches[i])
                    }
                } else {
                    List(0..<route.directions!.count) { i in
                        if let index = route.churchNames.firstIndex(of: route.directions![i]) {
                            ChurchRow(i: index, church: route.churches[index])
                        } else {
                            Text(route.directions![i])
                        }
                    }
                }
                
                LocationRow(type: "End", name: route.end, mapItem: route.locations[1].mapItem)
            }
            
            Section(header: Text("Contribute"), footer: Text(route.directions != nil ? "" : "This stage needs a title, description and detailed directions. If you would like to test this stage please follow the link above.")) {
                Button {
                    let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Contribute%20Photos")!
                    UIApplication.shared.open(url)
                } label: {
                    Label("Contribute Photos", systemImage: "photo")
                }
                
                if route.directions == nil {
                    NavigationLink(destination: ContributeView()) {
                        Label("Test this Stage", systemImage: "star")
                    }
                }
            }
        }
        .navigationTitle(route.stage)
        .toolbar {
            Button {
                vm.toggleVisitedRoute(route: route)
            } label: {
                Label("Completed", systemImage: vm.visitedRouteImage(id: route.id))
            }
        }
    }
}
