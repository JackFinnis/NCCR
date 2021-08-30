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
        NavigationView {
            ZStack {
                MapView()
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        MapSettings()
                    }
                    
                    Spacer()
                    HStack(spacing: 0) {
                        Spacer(minLength: 10)
                        ControlBox()
                            .frame(maxWidth: 450)
                    }
                }
                .animation(vm.animation)
            }
            .navigationTitle("See on map")
            .navigationBarHidden(true)
        }
        .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        .environmentObject(vm)
        .alert(isPresented: $vm.showMilestoneAlert) {
            Alert(
                title: Text("🎉 Congratulations! 🎉"),
                message: Text(vm.getMilestoneSummary()),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}
