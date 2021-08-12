//
//  CLLC2D.swift
//  CLLC2D
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let latitude = try container.decode(Double.self)
        let longitude = try container.decode(Double.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}
