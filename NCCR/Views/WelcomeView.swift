//
//  WelcomeView.swift
//  NCCR
//
//  Created by Jack Finnis on 02/09/2021.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(35)
                    .padding(10)
                
                Text("""
                    1300 miles of glorious cycling,
                    over 600 fascinating medieval churches,
                    and no hills!
                    """)
                .padding(10)
                
                Text("Welcome to The Norfolk Churches Cycle Route")
                    .padding(10)
                
                NavigationLink(destination: RoutesView()) {
                    Text("Explore the route!")
                        .font(.headline)
                        .padding()
                }
                
                Text("""
                    Please note this project is in the development and testing phase. There will be glitches!
                    Please follow the links in the info page if you would like to contribute photos and get involved in the project!
                    Justin & Jack
                    """)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(10)
            }
        }
        .padding()
        .multilineTextAlignment(.center)
        .navigationBarHidden(true)
    }
}

struct WelcomeView_Preview: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

