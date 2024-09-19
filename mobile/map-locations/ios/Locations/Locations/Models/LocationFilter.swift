//
//  LocationFilter.swift
//  Locations
//
//  Created by Austin Blaser on 9/19/24.
//

import Foundation

enum LocationFilterType: String, CaseIterable {
    case bar
    case cafe
    case landmark
    case museum
    case park
    case restaurant

    var label: String {
        return self.rawValue.capitalized
    }

    var iconName: String {
        return switch self {
        case .restaurant: "fork.knife"
        case .museum: "building.columns.fill"
        case .park: "tree.fill"
        case .landmark: "mappin.and.ellipse"
        case .cafe: "cup.and.saucer.fill"
        case .bar: "wineglass.fill"
        }
    }
}
