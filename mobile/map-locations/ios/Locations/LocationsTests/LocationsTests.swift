//
//  LocationsTests.swift
//  LocationsTests
//
//  Created by Austin Blaser on 9/18/24.
//

import Foundation
import Testing
@testable import Locations

struct LocationsTests {
    @Test func testDecode() async throws {
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
        #expect(location.attributes.count == 4)
        #expect(location.attributes.last!.value.label == "$10.5 million")
    }
}
