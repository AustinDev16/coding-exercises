//
//  MapViewModel.swift
//  Locations
//
//  Created by Austin Blaser on 9/20/24.
//

import Foundation

@Observable @MainActor
class MapViewModel {
    @ObservationIgnored private var allLocations: [LocationFilterType: [Location]]
    @ObservationIgnored private var hasLoaded = false

    var visibleLocations: [Location] = []
    var loading = true
    var showError = false
    var selectedFilters: [LocationFilterType] = []

    init() {
        var locations: [LocationFilterType: [Location]] = [:]
        for type in LocationFilterType.allCases {
            locations[type] = []
        }
        self.allLocations = locations
    }


    func getLocations(_ networking: LocationsService) async {
        guard !hasLoaded else { return }
        do {
            let locations = try await networking.getLocations()
            // Iterate over all locations here to place each location in the dictionary
            locations.forEach { loc in
                if let type = loc.locationType {
                    allLocations[type]?.append(loc)
                }
            }
            applyFilters([.bar])
            hasLoaded = true
        } catch {
            showError = true
        }
    }

    func applyFilters(_ filters: [LocationFilterType]) {
        selectedFilters = filters

        // My first pass was this. Every filter update would iterate over the whole data set.
//        visibleLocations = allLocations.filter { selectedFilters.contains($0.locationType!) }

        // Second pass is this. We already iterate over all the locations once, then only have to iterate over the number the selected filters (compactMap) and the number of locations in those arrays (flatMap). On small data sets the difference is neglible, on large data sets we save iterating over the whole list each time.
        visibleLocations = filters.compactMap { allLocations[$0] } .flatMap { $0 }
    }
}
