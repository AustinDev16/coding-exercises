//
//  MapView.swift
//  Locations
//
//  Created by Austin Blaser on 9/19/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    let networking: LocationsService
    @State var selectFiltersShowing = false
    @State var viewModel: MapViewModel = MapViewModel()
    @State var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.77493, longitude: -122.41942),
        span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
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
            filterButton
        }
        .navigationBarHidden(true)
        .navigationTitle("Map")
        .sheet(isPresented: $selectFiltersShowing) {
            SelectFilterView(selectedFilters: viewModel.selectedFilters, viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .task {
            await viewModel.getLocations(networking)
        }
    }

    private var filterButton: some View {
        Button(action: { selectFiltersShowing = true }) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.title)
        }
        .padding()
        .background {
            Color(uiColor: .systemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.trailing, 16)
    }
}

#Preview {
     NavigationStack {
         MapView(networking: MockLocationsService())
    }
}
