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
            Section(header: Text("Directions")) {
                HStack {
                    Text("Start")
                    Spacer()
                    Text(String(route.start))
                    Button {
                        route.locations[0].mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
                    } label: {
                        Image(systemName: "location.circle")
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
                    }
                }
            }
            
            Section(header: Text("Details")) {
                Row(leading: "Distance", trailing: vm.getFormattedDistanceWithUnit(metres: route.metres))
                Row(leading: "Churches", trailing: String(route.churches.count))
                Row(leading: "Church Density", trailing: vm.getFormattedDensity(route: route))
            }
            
            Section(header: Text("Churches")) {
                List(0..<route.churches.count) { i in
                    HStack {
                        Text(String(i+1))
                            .font(.headline)
                        Text(route.churches[i].name)
                            .lineLimit(1)
                        Spacer()
                        Button {
                            vm.toggleVisitedChurch(id: route.churches[i].id)
                        } label: {
                            Image(systemName: vm.visitedChurchImage(id: route.churches[i].id))
                        }
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
