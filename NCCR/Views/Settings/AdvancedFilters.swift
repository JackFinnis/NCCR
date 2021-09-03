//
//  AdvancedFilters.swift
//  NCCR
//
//  Created by Finnis on 12/08/2021.
//

import SwiftUI

struct AdvancedFilters: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var expandAnnotations: Bool = false
    @State var expandVisited: Bool = false
    @State var expandDistance: Bool = false
    @State var expandProximity: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $expandAnnotations) {
            Toggle("Show Routes", isOn: $vm.showRoutes)
            Toggle("Show Churches", isOn: $vm.showChurches)
        } label: {
            HStack {
                Text("Map Features")
                Spacer()
                Text(vm.filterAnnotationsSummary)
                    .foregroundColor(.secondary)
            }
        }
        
        DisclosureGroup(isExpanded: $expandVisited) {
            Toggle("Show Visited", isOn: $vm.showVisited)
                .toggleStyle(SwitchToggleStyle(tint: Color(UIColor.systemBlue)))
            Toggle("Show Unvisited", isOn: $vm.showUnvisited)
        } label: {
            HStack {
                Text("Visited Features")
                Spacer()
                Text(vm.filterVisitedSummary)
                    .foregroundColor(.secondary)
            }
        }
        
        DisclosureGroup(isExpanded: $expandDistance) {
            Slider(value: $vm.minimumDistance, in: 0...115_000, step: 5_000, minimumValueLabel: Text("Minimum"), maximumValueLabel: Text("")) {
                Text("Minimum Distance")
            }
            Slider(value: $vm.maximumDistance, in: 0...115_000, step: 5_000, minimumValueLabel: Text("Maximum"), maximumValueLabel: Text("")) {
                Text("Maximum Distance")
            }
        } label: {
            HStack {
                Text("Stage Distance")
                Spacer()
                Text(vm.filterDistanceSummary)
                    .foregroundColor(.secondary)
            }
        }
        
        DisclosureGroup(isExpanded: $expandProximity) {
            Slider(value: $vm.maximumProximity, in: 0...115_000, step: 5_000, minimumValueLabel: Text("Maximum"), maximumValueLabel: Text("")) {
                Text("Maximum Proximity")
            }
        } label: {
            HStack {
                Text("Stage Proximity")
                Spacer()
                Text(vm.filterProximitySummary)
                    .foregroundColor(.secondary)
            }
        }
    }
}
