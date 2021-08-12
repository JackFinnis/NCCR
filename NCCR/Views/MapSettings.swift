//
//  MapSettings.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import CoreLocation

struct MapSettings: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                vm.updateMapType()
            } label: {
                Image(systemName: vm.mapTypeImage)
                    .frame(width: 48, height: 48)
                    .animation(.none, value: vm.mapType)
            }
            
            Divider()
                .frame(width: 48)
            
            Button {
                vm.updateTrackingMode()
            } label: {
                Image(systemName: vm.trackingModeImage)
                    .frame(width: 48, height: 48)
                    .animation(.none, value: vm.trackingMode)
            }
        }
        .font(.system(size: 24))
        .background(Blur())
        .cornerRadius(10)
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .padding(.trailing, 10)
        .padding(.top, 50)
    }
}
