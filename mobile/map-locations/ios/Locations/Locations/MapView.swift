//
//  MapView.swift
//  Locations
//
//  Created by Austin Blaser on 9/19/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State var selectFiltersShowing = true
    var body: some View {
        Map {
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: { selectFiltersShowing = true }) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.title)
            }
            .padding()
            .background {
                Color(uiColor: .systemBackground)
            }
        }
        .sheet(isPresented: $selectFiltersShowing) {
            SelectFilterView()
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    MapView()
}

struct SelectFilterView: View {
    @State var selectedFilters: Set<LocationFilterType> = []
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
            } header: { Text("Location Type") }

            Section {
                Button("Reset", action: { reset() } )
                Button("Apply All", action: { applyAll() } )
            } footer: { Text("Apply all Filters") }
        }
        .onChange(of: selectedFilters) { _, newValue in
            print(newValue)
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
    SelectFilterView()
}
