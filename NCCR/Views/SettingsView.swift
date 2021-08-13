//
//  SettingsView.swift
//  SettingsView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Visited Features")) {
                    Label {
                        if vm.visitedFeatures.routes!.count == 26 {
                            Text("You have cycled every route!")
                        } else {
                            HStack {
                                Text(String(vm.visitedFeatures.routes!.count) + "/26 Routes ")
                                Spacer()
                                Text(vm.getDistanceCycledSummary())
                                    .foregroundColor(.secondary)
                            }
                        }
                    } icon: {
                        Image(systemName: "bicycle")
                    }
                    
                    Label {
                        if vm.visitedFeatures.churches!.count == 632 {
                            Text("You have visited every medieval church in Norfolk!")
                        } else {
                            Text(String(vm.visitedFeatures.churches!.count) + "/632 Churches")
                        }
                    } icon: {
                        Image("cross")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.accentColor)
                            .frame(height: 24)
                    }
                }
                
                Section(header: Text("Distance Unit")) {
                    Picker("Distance Unit", selection: $vm.distanceUnit) {
                        ForEach(DistanceUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Advanced Filters")) {
                    Toggle("Apply Filters", isOn: $vm.filter.animation())
                    if vm.filter {
                        AdvancedFilters()
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.showSettingsView = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
