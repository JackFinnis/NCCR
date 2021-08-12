//
//  TipView.swift
//  TipView
//
//  Created by William Finnis on 10/08/2021.
//

import SwiftUI

struct TipView: View {
    @StateObject var vm = TipViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Leave a Tip"), footer: Text("NCCR relies on your support to cover our costs and fund its development. If you like the Norfolk Churches Cycling Routes please consider leaving a tip in our tip jar. Thank you for your support.")) {
                ForEach(vm.tipChoices, id: \.self) { tip in
                    Button {
                        // todo
                    } label: {
                        Label {
                            HStack {
                                Text(tip.name)
                                Spacer()
                                Text("£" + String(format: "%.2f", tip.amount))
                                    .foregroundColor(.black)
                            }
                        } icon: {
                            Text(tip.emoji)
                                .font(.system(size: 24))
                        }
                    }
                }
            }
        }
        .navigationTitle("Tip Jar")
    }
}
