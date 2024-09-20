//
//  LocationsApp.swift
//  Locations
//
//  Created by Austin Blaser on 9/18/24.
//

import SwiftUI

@main
struct LocationsApp: App {
    @State private var path = NavigationPath()
    var body: some Scene {
        WindowGroup {
//            ContentView()
            NavigationStack(path: $path) {
                MapView(networking: GithubLocationsService(accountName: "AustinDev16"))
                    .navigationDestination(for: Location.self) { location in
                        LocationDetailView(location: location)
                    }
            }
        }
    }
}
