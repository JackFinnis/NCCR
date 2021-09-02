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
    
    var body: some View {
        Form {
            if route.routeTitle != nil || route.routeDescription != nil {
                Section(header: Text("Details")) {
                    if route.routeTitle != nil {
                        Text(route.routeTitle!)
                            .bold()
                    }
                    if route.routeDescription != nil {
                        Text(route.routeDescription!)
                    }
                }
            }
            
            Section(header: Text("Stats")) {
                Row(leading: "Distance", trailing: vm.getFormattedDistanceWithUnit(metres: route.metres))
                Row(leading: "Churches", trailing: String(route.churches.count))
                Row(leading: "Church Density", trailing: vm.getFormattedDensity(route: route))
            }
            
            Section(header: Text("Directions")) {
                HStack {
                    Text("Start")
                    Spacer()
                    Text(String(route.start))
                    Button {
                        route.locations[0].mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
                    } label: {
                        Image(systemName: "location.circle")
                            .font(.system(size: 24))
                    }
                }
                
                if route.directions == nil {
                    List(0..<route.churches.count) { i in
                        ChurchRow(i: i, church: route.churches[i])
                            .buttonStyle(BorderlessButtonStyle())
                    }
                } else {
                    List(route.directions!, id:\.self) { line in
                        if let index = route.churchNames.firstIndex(of: line) {
                            ChurchRow(i: index, church: route.churches[index])
                        } else {
                            Text(line)
                        }
                    }
                }
                
                HStack {
                    Text("End")
                    Spacer()
                    Text(String(route.end))
                    Button {
                        route.locations[1].mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
                    } label: {
                        Image(systemName: "location.circle")
                            .font(.system(size: 24))
                    }
                }
            }
            
            if route.directions == nil {
                Section(header: Text("Contribute"), footer: Text("This route needs a title, description, detailed directions and some photos. If you would like to contribute any of these details please follow the link above")) {
                    NavigationLink(destination: ContributeView()) {
                        Label("Contribute", systemImage: "star")
                    }
                }
            }
        }
        .navigationTitle(route.stage)
        .toolbar {
            Button {
                vm.toggleVisitedRoute(route: route)
            } label: {
                Image(systemName: vm.visitedRouteImage(id: route.id))
            }
        }
    }
}
