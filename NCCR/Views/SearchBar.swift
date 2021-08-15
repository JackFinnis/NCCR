//
//  SearchBar.swift
//  NCCR
//
//  Created by Finnis on 14/08/2021.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @EnvironmentObject var vm: ViewModel
    
    let placeholder = "Churches and Destinations"
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = vm
        searchBar.placeholder = placeholder
        searchBar.backgroundImage = UIImage()
        searchBar.autocorrectionType = .no
        searchBar.textContentType = .location
        
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: Context) {
        searchBar.text = vm.searchText
        searchBar.placeholder = placeholder
        
        if vm.searchBarshowCancelButton && !vm.showCancelButton {
            vm.searchBarshowCancelButton = false
            searchBar.resignFirstResponder()
        }
    }
}
