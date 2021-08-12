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
                    Text(String(Int(route.metres / 1_000)) + " km")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(String(route.churches.count) + " Churches")
                    Text(String(format: "%.1f", route.density) + " km/Church")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
    }
}
