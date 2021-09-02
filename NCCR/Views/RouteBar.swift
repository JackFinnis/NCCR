//
//  RouteBar.swift
//  RouteBar
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct RouteBar: View {
    @EnvironmentObject var vm: ViewModel
    
    let route: Route
    let index: Int
    
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
            
            NavigationLink(destination: RouteView(route: route).environmentObject(vm)) {
                RouteInfo(route: route)
                    .frame(idealHeight: 96)
            }
            
            VStack(spacing: 0) {
                NavigationLink(destination: RouteView(route: route).environmentObject(vm)) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24))
                        .frame(width: 48, height: 48)
                }
                Button {
                    vm.selectedRoute = nil
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .frame(width: 48, height: 48)
                }
            }
        }
    }
}
