//
//  MapViewModel.swift
//  Locations
//
//  Created by Austin Blaser on 9/20/24.
//

import Foundation

@Observable
class MapViewModel {
    @ObservationIgnored private var allLocations: [Location] = []
    var visibleLocations: [Location] = []
    var loading = true
    var showError = false
    var selectedFilters: [LocationFilterType] = []


    func getLocations(_ networking: LocationsService) async {
        guard allLocations.isEmpty else { return }
        do {
            let locations = try await networking.getLocations()
            allLocations = locations
            applyFilters([.museum, .park])
        } catch {
            showError = true
        }
    }

    func applyFilters(_ filters: [LocationFilterType]) {
        selectedFilters = filters
        visibleLocations = allLocations.filter { selectedFilters.contains($0.locationType!) }
    }
}
