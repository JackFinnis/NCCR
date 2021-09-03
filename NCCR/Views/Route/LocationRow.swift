//
//  LocationRow.swift
//  NCCR
//
//  Created by Jack Finnis on 03/09/2021.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationRow: View {
    let type: String
    let name: String
    let mapItem: MKMapItem
    
    var body: some View {
        HStack {
            Text(type)
            Spacer()
            Text(name)
            Button {
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
            } label: {
                Image(systemName: "location.circle")
                    .font(.system(size: 24))
            }
        }
    }
}
