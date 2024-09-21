//
//  GithubLocationsService.swift
//  Locations
//
//  Created by Austin Blaser on 9/20/24.
//

import Foundation

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
