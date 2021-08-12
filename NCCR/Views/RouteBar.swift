//
//  RouteBar.swift
//  RouteBar
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct RouteBar: View {
    @EnvironmentObject var vm: ViewModel
    
    var route: Route
    var index: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Text(String(index + 1))
                    .bold()
                
                VStack(spacing: 0) {
                    Button {
                        vm.previousRoute()
                    } label: {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 24))
                            .frame(width: 48, height: 48)
                    }
                    Button {
                        vm.nextRoute()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 24))
                            .frame(width: 48, height: 48)
                    }
                }
            }
            
            RouteInfo(route: route)
                .frame(idealHeight: 96)
            
            VStack(spacing: 0) {
                Button {
                    vm.toggleVisitedRoute(route: route)
                } label: {
                    Image(systemName: vm.visitedRouteImage(id: route.id))
                        .font(.system(size: 24))
                        .frame(width: 48, height: 48)
                        .foregroundColor(vm.visitedRoute(id: route.id) ? Color(UIColor.systemPink) : .accentColor)
                }
                Button {
                    vm.selectedRoute = nil
                    vm.zoomOut.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .frame(width: 48, height: 48)
                }
            }
        }
    }
}
