//
//  MockLocationsService.swift
//  Locations
//
//  Created by Austin Blaser on 9/20/24.
//

import Foundation

class MockLocationsService: LocationsService {
    func getLocations() async throws -> [Location] {
        let jsonString = """
{
        "id": 1,
        "latitude": 37.7750,
        "longitude": -122.4195,
        "attributes": [
            {
                "type": "location_type",
                "value": "restaurant"
            },
            {
                "type": "name",
                "value": "Golden Gate Grill"
            },
            {
                "type": "description",
                "value": "A popular eatery with views of the bay."
            },
            {
                "type": "estimated_revenue_millions",
                "value": 10.5
            }
        ]
    }
"""
        let location = try JSONDecoder().decode(Location.self, from: jsonString.data(using: .utf8)!)
        return [location]
    }
}
