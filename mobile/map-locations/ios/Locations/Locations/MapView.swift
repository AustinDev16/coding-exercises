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
        Map(position: $cameraPosition, interactionModes: [.all]) {
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
                    .font(.title)
                    .onTapGesture {
                        print("tap: \(location.name)")
                    }
                }
                .annotationTitles(.visible)
            }
        }
        .mapStyle(.standard(elevation: .flat,
                            emphasis: .muted,
                            pointsOfInterest: .excludingAll,
                            showsTraffic: false
                           )
        )
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
            SelectFilterView(selectedFilters: viewModel.selectedFilters, viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .task {
            await viewModel.getLocations(networking)
        }
    }
}

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
           print("An error occurred: \(error)")
            showError = true
        }

    }

    func applyFilters(_ filters: [LocationFilterType]) {
        print("VM FILTERS: \(filters)")
        selectedFilters = filters
        visibleLocations = allLocations.filter { selectedFilters.contains($0.locationType!) }
    }
}

#Preview {
    return NavigationStack {
        MapView(networking: GithubLocationsService(accountName: "AustinDev16"))
    }
}

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
            } header: { Text("Location Type") }

            Section {
                Button("Reset", action: { reset() } )
                Button("Apply All", action: { applyAll() } )
            } footer: { Text("Apply all Filters") }
        }
        .onChange(of: selectedFilters) { _, filters in
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
