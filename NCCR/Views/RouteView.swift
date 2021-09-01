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
            if route.routeTitle != nil {
                Section(header: Text("Details")) {
                    Text(route.routeTitle!)
                        .bold()
                    Text(route.routeDescription!)
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
            
            Section(header: Text("Contribute"), footer: Text(route.directions != nil ? "" : "This route needs a title, description and detailed directions. If you would like to contribute these details please contact us above.")) {
                Button {
                    let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Contribute")!
                    UIApplication.shared.open(url)
                } label: {
                    Label("Contribute Photos", systemImage: "photo")
                }
                Button {
                    let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Contribute")!
                    UIApplication.shared.open(url)
                } label: {
                    Label("Contribute Details", systemImage: "square.and.pencil")
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
