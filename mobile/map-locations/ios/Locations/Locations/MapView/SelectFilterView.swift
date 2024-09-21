//
//  SelectFilterView.swift
//  Locations
//
//  Created by Austin Blaser on 9/20/24.
//

import SwiftUI

struct SelectFilterView: View {
    @State var selectedFilters: Set<LocationFilterType> = []
    let viewModel: MapViewModel

    init(selectedFilters: [LocationFilterType], viewModel: MapViewModel) {
        self.selectedFilters = Set<LocationFilterType>(selectedFilters)
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section {
                ForEach(LocationFilterType.allCases, id: \.self) { type in
                    Toggle(type.label,
                           systemImage: type.iconName,
                           isOn: Binding(
                            get: { selectedFilters.contains(type) },
                            set: { newValue in
                                if newValue {
                                    selectedFilters.insert(type)
                                } else {
                                    selectedFilters.remove(type)
                                }
                            }
                           )
                    )
                        .tint(Color.blue)
                }
            } header: { Text("Filter by Location Type") }

            Section {
                Button("Clear", action: { reset() } )
                Button("Show All", action: { applyAll() } )
            }
        }
        .onChange(of: selectedFilters) { _, filters in
            // Updates view model and map view
            viewModel.applyFilters(Array(filters))
        }
    }

    private func reset() {
        selectedFilters.removeAll()
    }

    private func applyAll() {
        selectedFilters = Set<LocationFilterType>(LocationFilterType.allCases)
    }
}

#Preview {
    SelectFilterView(selectedFilters: [.landmark], viewModel: MapViewModel())
}
