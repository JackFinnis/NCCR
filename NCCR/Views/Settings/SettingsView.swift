//
//  SettingsView.swift
//  SettingsView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Visited Summary")) {
                    Label {
                        Text(vm.getVisitedRoutesSummary())
                    } icon: {
                        Image(systemName: "bicycle")
                    }
                    
                    Label {
                        Text(vm.getDistanceCycledSummary())
                    } icon: {
                        Image(systemName: "ruler")
                    }
                    
                    Label {
                        Text(vm.getVisitedChurchesSummary())
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
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
}
