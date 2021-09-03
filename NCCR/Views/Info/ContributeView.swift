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
        VStack(alignment: .leading) {
            Text("The Norfolk Churches Cycle Route has been planned on paper. We would be very pleased if people wanted to test stages in the route using the app and then send in short written descriptions of and directions between each church in a stage. We have done this for Stage 1 as an example. Route Testers will be acknowledged and invited to the public launch of The NCCR next year.")
                .padding(5)
            Text("If you would like to contribute then please email us by clicking on the link below.")
                .padding(5)
            Button {
                let url = URL(string: "mailto:" + email + "?subject=NCCR:%20Get%20involved!")!
                UIApplication.shared.open(url)
            } label: {
                HStack {
                    Spacer()
                    Text("Get involved!")
                        .bold()
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Test a Stage")
    }
}
