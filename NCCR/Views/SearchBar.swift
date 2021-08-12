//
//  SearchBar.swift
//  SearchBar
//
//  Created by William Finnis on 07/08/2021.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    private var placeholder = ""
    
    init(text: Binding<String>) {
        _text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
    
    func placeholder(_ string: String) -> SearchBar {
        var searchBar = self
        searchBar.placeholder = string
        return searchBar
    }
}
