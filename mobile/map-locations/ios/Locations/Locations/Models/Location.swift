//
//  Location.swift
//  Locations
//
//  Created by Austin Blaser on 9/18/24.
//

import Foundation
import MapKit

struct Location: Decodable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let attributes: [Attribute]
}

extension Location {
    var name: String {
        self.attributes.first { $0.attributeType == .name }?.value.label ?? ""
    }

    var description: String {
        self.attributes.first { $0.attributeType == .description }?.value.label ?? ""
    }

    var estimatedRevenue: String {
        self.attributes.first { $0.attributeType == .estimated_revenue_millions }?.value.label ?? ""
    }

    var locationType: LocationFilterType? {
        if let attribute = self.attributes.first(where: { $0.attributeType == .location_type }) {
            return LocationFilterType(rawValue: attribute.value.label.lowercased())
        } else {
            return nil
        }
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Location: Hashable, Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
