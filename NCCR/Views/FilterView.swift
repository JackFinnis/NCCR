//
//  FilterView.swift
//  FilterView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Apply Filters", isOn: $vm.filter.animation())
                
                if vm.filter {
                    Section(header: Text("Advanced Filters")) {
                        DisclosureGroup(isExpanded: $vm.expandAnnotations) {
                            Toggle("Show Routes", isOn: $vm.showRoutes)
                                .toggleStyle(SwitchToggleStyle(tint: Color(UIColor.systemBlue)))
                            Toggle("Show Churches", isOn: $vm.showChurches)
                        } label: {
                            HStack {
                                Text("Map Features")
                                Spacer()
                                Text(vm.filterAnnotationsSummary)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section {
                        DisclosureGroup(isExpanded: $vm.expandVisited) {
                            Toggle("Show Visited", isOn: $vm.showVisited)
                                .toggleStyle(SwitchToggleStyle(tint: Color(UIColor.systemPink)))
                            Toggle("Show Unvisited", isOn: $vm.showUnvisited)
                        } label: {
                            HStack {
                                Text("Visited Features")
                                Spacer()
                                Text(vm.filterVisitedSummary)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section {
                        DisclosureGroup(isExpanded: $vm.expandDistance) {
                            Slider(value: $vm.minimumDistance, in: 0...115, step: 5, minimumValueLabel: Text("Minimum"), maximumValueLabel: Text("")) {
                                Text("Minimum Distance")
                            }
                            Slider(value: $vm.maximumDistance, in: 0...115, step: 5, minimumValueLabel: Text("Maximum"), maximumValueLabel: Text("")) {
                                Text("Maximum Distance")
                            }
                        } label: {
                            HStack {
                                Text("Route Distance")
                                Spacer()
                                Text(vm.filterDistanceSummary)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section {
                        DisclosureGroup(isExpanded: $vm.expandProximity) {
                            Slider(value: $vm.maximumProximity, in: 0...115, step: 5, minimumValueLabel: Text("Maximum"), maximumValueLabel: Text("")) {
                                Text("Maximum Proximity")
                            }
                        } label: {
                            HStack {
                                Text("Route Proximity")
                                Spacer()
                                Text(vm.filterProximitySummary)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Advanced Filters")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.showFilterView = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
