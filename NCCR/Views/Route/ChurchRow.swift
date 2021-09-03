//
//  ChurchRow.swift
//  NCCR
//
//  Created by Jack Finnis on 01/09/2021.
//

import SwiftUI

struct ChurchRow: View {
    @EnvironmentObject var vm: ViewModel
    
    let i: Int
    let church: Church
    
    var body: some View {
        HStack {
            Text(String(i+1))
                .font(.headline)
            Text(church.name)
            Spacer()
            Button {
                vm.toggleVisitedChurch(id: church.id)
            } label: {
                Image(systemName: vm.visitedChurchImage(id: church.id))
                    .font(.system(size: 24))
            }
            Button {
                UIApplication.shared.open(church.url)
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 24))
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
