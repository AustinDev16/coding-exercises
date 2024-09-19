//
//  LocationDetailView.swift
//  Locations
//
//  Created by Austin Blaser on 9/19/24.
//

import SwiftUI

struct LocationDetailView: View {
    let location: Location

    var body: some View {
            List {
                Section {
                    HStack {
                        Image(systemName: location.locationType?.iconName ?? "arrow")
                        Text(location.locationType?.label ?? "")
                            .font(.body)
                    }
                } header: { Text("What is it?") }

                Section {
                    Text(location.description)
                        .font(.body)
                } header: { Text("More Info") }

                Section {
                    Text(location.estimatedRevenue)
                } header: { Text("Estimated Revenue") }


            }
            .listStyle(.insetGrouped)
//            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle(location.name)
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(location: MockData.location())
    }
}

struct MockData {
    static func location() -> Location {
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
        let location = try! JSONDecoder().decode(Location.self, from: jsonString.data(using: .utf8)!)
        return location
    }
}
