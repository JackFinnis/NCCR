//
//  ContributeView.swift
//  NCCR
//
//  Created by Jack Finnis on 02/09/2021.
//

import SwiftUI

struct ContributeView: View {
    let email: String = "contact.nccr@gmail.com"
    
    var body: some View {
        VStack {
            Text("If you have any ideas for new features to improve the app you can submit them here. If you have any pictures from your routes that you would like to share you can submit them here to be included in the app!")
            Button {
                let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Contribute")!
                UIApplication.shared.open(url)
            } label: {
                Text("Contribute")
            }
        }
        .navigationTitle("Contribute")
    }
}
