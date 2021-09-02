//
//  InfoView.swift
//  InfoView
//
//  Created by William Finnis on 10/08/2021.
//

import SwiftUI
import StoreKit

struct InfoView: View {
    @EnvironmentObject var vm: ViewModel
    
    let email: String = "contact.nccr@gmail.com"
    let appUrl: String = "https://itunes.apple.com/app/id1580773042"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Label("About NCCR", systemImage: "info.circle")
                    }
                }
                
                Section(header: Text("Feedback")) {
                    Button {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    } label: {
                        Label("Rate NCCR", systemImage: "hand.thumbsup")
                    }
                    
                    Button {
                        let productUrl = URL(string: appUrl)!
                        var components = URLComponents(url: productUrl, resolvingAgainstBaseURL: false)
                        components?.queryItems = [
                            URLQueryItem(name: "action", value: "write-review")
                        ]
                        if let url = components?.url {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Review on the App Store", systemImage: "text.bubble")
                    }
                    
                    Button {
                        vm.showShareView = true
                    } label: {
                        Label("Share NCCR", systemImage: "square.and.arrow.up")
                    }
                    
                    NavigationLink(destination: ContributeView()) {
                        Label("Contribute", systemImage: "star")
                    }
                }
            }
            .navigationTitle("Feedback")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.showInfoView = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .sheet(isPresented: $vm.showShareView) {
            ShareView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        }
    }
}
