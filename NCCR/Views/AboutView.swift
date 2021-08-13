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
    
    var body: some View {
        List {
            Section(header: Text("NCCR")) {
                Text("The Norfolk Churches Cycling Routes are a series of cycling routes around Norfolk which visit all of its medieval churches.")
            }
            
            Section(header: Text("The Churches")) {
                Text("Norfolk has the highest density of medieval churches in the world. The routes visit 632 churches and each church has substantial medieval fabric.")
            }
            
            Section(header: Text("The Routes")) {
                Text("There are 26 routes covering over " + vm.getFormattedDistanceWithUnit(metres: vm.totalMetres) + " of beautiful Norfolk countryside. Each route starts and ends at a town with a car park and every other town also has a train station for ease of access.")
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
