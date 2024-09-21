//
//  LocationsService.swift
//  Locations
//
//  Created by Austin Blaser on 9/19/24.
//

import Foundation

protocol LocationsService {
    func getLocations() async throws -> [Location]
}
