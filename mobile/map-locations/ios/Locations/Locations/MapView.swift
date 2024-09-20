//
//  MapView.swift
//  Locations
//
//  Created by Austin Blaser on 9/19/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State var selectFiltersShowing = false
    @State var viewModel: MapViewModel = MapViewModel()
    @State var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.77493, longitude: -122.41942), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
    let networking: LocationsService
    @State var selectedLocation: Location?
    @State var showSelectedLocation = false

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(viewModel.visibleLocations, id: \.id) { location in
                Annotation(location.name, coordinate: location.coordinate) {
                    VStack {
                        if let iconName = location.locationType?.iconName {
                            NavigationLink(value: location) {
                                Image(systemName: iconName)
                                    .foregroundStyle(Color.blue)
                            }
                        }
                    }
                    .font(.caption)
                    .onTapGesture {
                        print("tap: \(location.name)")
                    }
                }
                .annotationTitles(.automatic)

            }
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
        .navigationBarHidden(true)
        .navigationTitle("Map")
//        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $selectFiltersShowing) {
            SelectFilterView()
                .presentationDetents([.medium, .large])
        }
        .task {
            await viewModel.getLocations(networking)
        }
    }
}

@Observable
class MapViewModel {
    var visibleLocations: [Location] = []
    @ObservationIgnored private var allLocations: [Location] = []
    var loading = true
    var showError = false


    func getLocations(_ networking: LocationsService) async {
        do {
            let locations = try await networking.getLocations()
            visibleLocations = locations
        } catch {
           print("An error occurred: \(error)")
            showError = true
        }

    }

    func applyFilters(_ filters: [LocationFilterType]) {

    }
}

#Preview {
    return NavigationStack {
        MapView(networking: GithubLocationsService(accountName: "AustinDev16"))
    }
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
