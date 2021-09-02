//
//  WelcomeView.swift
//  NCCR
//
//  Created by Jack Finnis on 02/09/2021.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(35)
                .padding(10)
            
            VStack {
                Text("1300 miles of glorious cycling,")
                Text("over 600 fascinating medieval churches,")
                Text("and no hills!")
            }
            .padding(10)
            
            Text("Welcome to The Norfolk Churches Cycling Routes")
                .padding(10)
            
            NavigationLink(destination: RoutesView()) {
                Text("Explore the routes!")
                    .font(.headline)
                    .padding()
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

