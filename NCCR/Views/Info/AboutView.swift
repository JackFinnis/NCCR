//
//  AboutView.swift
//  AboutView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var vm: ViewModel
    @Environment(\.colorScheme) var colourScheme
    
    var routesText: String {
        "There are " + String(vm.routes.count) + " stages of the route covering over " + vm.getFormattedDistanceWithUnit(metres: vm.getTotalMetres()) + " of beautiful Norfolk countryside. Each stage starts and ends at a town with a car park and every other town also has a train station for ease of access."
    }
    
    var body: some View {
        List {
            Section(header: Text("NCCR")) {
                Text("The Norfolk Churches Cycle Route is a cycle route around Norfolk which visit all of its medieval churches.")
            }
            
            Section(header: Text("The Churches")) {
                Text("Norfolk has the highest density of medieval churches in the world. The route visits " + String(vm.churches.count) + " churches and each church has substantial medieval fabric.")
            }
            
            Section(header: Text("The Stages")) {
                Text(routesText)
            }
            
            Section(header: Text("Acknowledgments")) {
                Button {
                    let url = URL(string: "http://norfolkchurches.co.uk/mainpage.htm")!
                    UIApplication.shared.open(url)
                } label: {
                    Text("With thanks to Simon Knott for supplying a detailed analysis of every church in Norfolk on his ") +
                    Text("website")
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .foregroundColor(colourScheme == .light ? .black : .white)
        .listStyle(SidebarListStyle())
        .navigationTitle("About")
    }
}
