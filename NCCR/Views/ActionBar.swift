//
//  ActionBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct ActionBar: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                vm.showFilterView = true
                vm.filter = true
            } label: {
                Image(systemName: vm.filterImage)
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            Menu {
                ForEach(SortBy.allCases, id: \.self) { sortBy in
                    Button {
                        vm.sortBy = sortBy
                    } label: {
                        Text(sortBy.rawValue)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            
            Spacer()
            if vm.loading {
                ProgressView()
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
                Spacer()
            }
            
            Button {
                if vm.showSearchBar == false {
                    vm.showSearchBar = true
                } else {
                    vm.showSearchBar = false
                    vm.searchText = ""
                }
            } label: {
                Image(systemName: vm.showSearchBarImage)
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            Button {
                vm.showInfoView = true
            } label: {
                Image(systemName: vm.showInfoImage)
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
        }
        .sheet(isPresented: $vm.showInfoView) {
            InfoView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
        .sheet(isPresented: $vm.showFilterView) {
            FilterView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
    }
}
