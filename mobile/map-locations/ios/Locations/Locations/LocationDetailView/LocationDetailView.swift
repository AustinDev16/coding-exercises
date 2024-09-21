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
            .navigationTitle(location.name)
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(location: PreviewData.location())
    }
}
