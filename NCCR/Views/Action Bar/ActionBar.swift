//
//  ActionBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct ActionBar: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var showSettingsView: Bool = false
    @State var showInfoView: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                showSettingsView = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            
            Group {
                Spacer()
                if vm.loading == .loading {
                    ProgressView()
                } else if vm.loading == .loaded {
                    Menu {
                        ForEach(SortBy.allCases.sorted { $0.rawValue > $1.rawValue }, id: \.self) { sortBy in
                            Button {
                                vm.sortBy = sortBy
                            } label: {
                                Text(sortBy.rawValue)
                            }
                        }
                    } label: {
                        Text("Sort Stages")
                    }
                    .frame(height: 48)
                } else {
                    Button {
                        vm.loading = .loading
                        vm.loadRoutes()
                    } label: {
                        Text("Reload")
                    }
                }
                Spacer()
            }
            .animation(.none, value: vm.loading)
            
            Button {
                showInfoView = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
        }
        .sheet(isPresented: $showInfoView) {
            InfoView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
    }
}
