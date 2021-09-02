//
//  RootView.swift
//  NCCR
//
//  Created by Jack Finnis on 02/09/2021.
//

import SwiftUI

struct RootView: View {
    var launchedBefore: Bool {
        if UserDefaults.standard.bool(forKey: "lauchedBefore") {
            return true
        } else {
            UserDefaults.standard.set(true, forKey: "lauchedBefore")
            return false
        }
    }
    
    var body: some View {
        NavigationView {
            if launchedBefore {
                RoutesView()
            } else {
                WelcomeView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
