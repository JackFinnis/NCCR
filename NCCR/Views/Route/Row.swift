//
//  Row.swift
//  Petition
//
//  Created by Jack Finnis on 19/08/2021.
//

import SwiftUI

struct Row: View {
    let leading: String
    let trailing: String
    
    var body: some View {
        HStack {
            Text(leading)
            Spacer()
            Text(trailing)
                .foregroundColor(.secondary)
        }
    }
}
