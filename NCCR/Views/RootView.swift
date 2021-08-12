//
//  RootView.swift
//  RootView
//
//  Created by William Finnis on 05/08/2021.
//

import SwiftUI
import CoreLocation

struct RootView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    MapSettings()
                }
                HStack(spacing: 0) {
                    Spacer(minLength: 10)
                    ControlBox()
                        .frame(maxWidth: 450)
                }
            }
            .animation(vm.animation)
        }
        .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        .environmentObject(vm)
    }
}
