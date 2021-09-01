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
                
                Section(header: Text("Feedback"), footer: Text("If you have any ideas for new features to improve the app you can submit them here.")) {
                    Button {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    } label: {
                        Label("Rate NCCR", systemImage: "star")
                    }
                    
                    Button {
                        let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Feedback")!
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Send us Feedback", systemImage: "envelope")
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
                }
                
                Section(header: Text("Contribute"), footer: Text("If you have any pictures from your routes that you would like to share you can submit them here to be included in the app!")) {
//                    NavigationLink(destination: TipView()) {
//                        Label("Tip Jar", systemImage: "heart")
//                    }
                    
                    Button {
                        vm.showShareView = true
                    } label: {
                        Label("Share NCCR", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Contribute")!
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Contribute Photos", systemImage: "photo")
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
