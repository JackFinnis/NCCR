//
//  AdvancedFilters.swift
//  NCCR
//
//  Created by Finnis on 12/08/2021.
//

import SwiftUI

struct AdvancedFilters: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
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
        
        DisclosureGroup(isExpanded: $vm.expandDistance) {
            Slider(value: $vm.minimumDistance, in: 0...115_000, step: 5_000, minimumValueLabel: Text("Minimum"), maximumValueLabel: Text("")) {
                Text("Minimum Distance")
            }
            Slider(value: $vm.maximumDistance, in: 0...115_000, step: 5_000, minimumValueLabel: Text("Maximum"), maximumValueLabel: Text("")) {
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
        
        DisclosureGroup(isExpanded: $vm.expandProximity) {
            Slider(value: $vm.maximumProximity, in: 0...115_000, step: 5_000, minimumValueLabel: Text("Maximum"), maximumValueLabel: Text("")) {
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
