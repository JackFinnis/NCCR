//
//  ShareView.swift
//  ShareView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI
import UIKit

struct ShareView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let shareItems = [URL(string: "https://itunes.apple.com/app/id1580773042")!]
        return UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
