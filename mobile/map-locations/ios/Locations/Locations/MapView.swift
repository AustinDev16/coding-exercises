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
            Text("FILTERS")
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    MapView()
}
