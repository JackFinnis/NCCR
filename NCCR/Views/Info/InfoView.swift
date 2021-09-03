//
//  InfoView.swift
//  InfoView
//
//  Created by William Finnis on 10/08/2021.
//

import SwiftUI
import StoreKit

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    
    @State var showShareView: Bool = false
    
    let email: String = "contact.nccr@gmail.com"
    let appUrl: String = "https://itunes.apple.com/app/id1580773042"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NCCR")) {
                    Button {
                        showShareView = true
                    } label: {
                        Label("Share NCCR", systemImage: "square.and.arrow.up")
                    }
                    
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
                        let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Feedback")!
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Send us Feedback", systemImage: "envelope")
                    }
                }
                
                Section(header: Text("Contribute"), footer: Text("Many stages still need a title, description and detailed directions. If you would like to test a stage please follow the link above.")) {
                    Button {
                        let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Contribute%20Photos")!
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Contribute Photos", systemImage: "photo")
                    }
                    
                    NavigationLink(destination: ContributeView()) {
                        Label("Test a Stage", systemImage: "star")
                    }
                }
            }
            .navigationTitle("Feedback")
            .toolbar {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .sheet(isPresented: $showShareView) {
            ShareView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        }
    }
}
