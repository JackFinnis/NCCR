//
//  ControlBox.swift
//  ControlBox
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct ControlBox: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ActionBar()
                .frame(maxHeight: 48)
            Divider()
            
            if vm.showSearchBar {
                SearchBar(text: $vm.searchText)
                    .placeholder("Churches and Destinations")
            }
            
            if vm.selectedRoute != nil && vm.filteredRoutes.firstIndex(of: vm.selectedRoute!) != nil {
                RouteBar(route: vm.selectedRoute!, index: vm.filteredRoutes.firstIndex(of: vm.selectedRoute!)!)
                    .animation(.none)
            }
        }
        .background(Blur())
        .cornerRadius(10)
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .padding(.trailing, 10)
        .padding(.vertical, 10)
    }
}
