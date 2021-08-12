//
//  TipViewModel.swift
//  TipViewModel
//
//  Created by William Finnis on 10/08/2021.
//

import Foundation

class TipViewModel: ObservableObject {
    @Published var tipChoices: [Tip] = [
        Tip(emoji: "😀", name: "Chapel-sized Tip", amount: 1),
        Tip(emoji: "😍", name: "Church-sized Tip", amount: 3),
        Tip(emoji: "😱", name: "Cathedral-sized Tip", amount: 10)
    ]
}
