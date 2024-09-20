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

struct GithubLocationsService: LocationsService {
    enum NetworkError: Error {
        case badURL
    }

    let accountName: String
    private var locationsURLString: String {
        "https://raw.githubusercontent.com/\(accountName)/coding-exercises/master/mobile/map-locations/locations.json"
    }


    func getLocations() async throws -> [Location] {
        guard let url = URL(string: locationsURLString) else { throw NetworkError.badURL }
        let request = URLRequest(url: url)

        let session = URLSession.shared
        let (data, response) = try await session.data(for: request)
        let locations: [Location] = try JSONDecoder().decode([Location].self, from: data)
        return locations
    }
}

