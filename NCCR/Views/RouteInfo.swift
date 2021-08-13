//
//  RouteInfo.swift
//  RouteInfo
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI
import MapKit

struct RouteInfo: View {
    @EnvironmentObject var vm: ViewModel
    
    var route: Route
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(route.name)
                .font(.headline)
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
}
