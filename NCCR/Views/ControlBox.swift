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
        Group {
            if vm.selectedRoute != nil && vm.filteredRoutes.firstIndex(of: vm.selectedRoute!) != nil {
                RouteBar(route: vm.selectedRoute!, index: vm.filteredRoutes.firstIndex(of: vm.selectedRoute!)!)
            } else {
                VStack(spacing: 0) {
                    ActionBar()
                        .frame(height: 48)
                    Divider()
                    HStack(spacing: 0) {
                        SearchBar()
                        if vm.showCancelButton {
                            Button {
                                vm.showCancelButton = false
                                vm.searchText = ""
                            } label: {
                                Text("Cancel")
                            }
                            .transition(.move(edge: .trailing))
                            .padding(.trailing, 10)
                        }
                    }
                }
            }
        }
        .transition(.move(edge: .bottom))
        .background(Blur())
        .cornerRadius(10)
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .padding(.trailing, 10)
        .padding(.vertical, 10)
    }
}
