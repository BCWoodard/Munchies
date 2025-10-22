//
//  RestaurantDetailCard.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import SwiftUI

struct RestaurantDetailCard: View {
    let restaurant: Restaurant
    let filters: [Filter]
    let isOpen: Bool?
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Restaurant Name
            Text(restaurant.name)
                .font(.helvetica(size: 24))
                .foregroundStyle(Color.darkText)
                .lineLimit(2)
                .accessibilityIdentifier("detailRestaurantName")

            // Filter Tags
            Text(restaurant.filterTagsText(from: filters))
                .font(.helvetica(size: 16))
                .foregroundStyle(Color.subtitle)
                .lineLimit(2)
                .accessibilityIdentifier("detailRestaurantFilters")

            // Open/Closed Status
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(height: 24)
                    .accessibilityIdentifier("detailStatusLoading")
            } else if let isOpen = isOpen {
                Text(isOpen ? "Open" : "Closed")
                    .font(.helvetica(size: 18))
                    .foregroundColor(isOpen ? Color.positive : Color.negative)
                    .accessibilityIdentifier("detailRestaurantStatus")
            } else {
                Text("Status unavailable")
                    .font(.helvetica(size: 18))
                    .foregroundColor(.gray)
                    .accessibilityIdentifier("detailRestaurantStatus")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
        )
    }
}

#Preview {
    RestaurantDetailCard(
        restaurant: .mock,
        filters: Filter.mockFilters,
        isOpen: true,
        isLoading: false
    )
    .padding()
    .background(Color.background)
}
