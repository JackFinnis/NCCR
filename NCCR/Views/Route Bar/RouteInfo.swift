//
//  RouteInfo.swift
//  RouteInfo
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI
import MapKit

struct RouteInfo: View {
    @Environment(\.colorScheme) var colourScheme
    @EnvironmentObject var vm: ViewModel
    
    let route: Route
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(route.name)
                    .font(.headline)
                    .foregroundColor(colourScheme == .light ? .black : .white)
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(route.stage)
                        Text(vm.getFormattedDistanceWithUnit(metres: route.metres))
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(String(route.churches.count) + " Churches")
                        Text(vm.getFormattedDensity(route: route))
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding(.vertical, 10)
        }
        .onTapGesture {
            vm.selectedRoute = route
        }
    }
}
