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
        VStack(alignment: .leading, spacing: 0) {
            Text(restaurant.name)
                .font(.helvetica(size: 24))
                .foregroundStyle(Color.darkText)
                .lineLimit(2)
                .frame(height: 42, alignment: .top)
                .accessibilityIdentifier("detailRestaurantName")

            Text(restaurant.filterTagsText(from: filters))
                .font(.helvetica(size: 16))
                .foregroundStyle(Color.subtitle)
                .lineLimit(2)
                .accessibilityIdentifier("detailRestaurantFilters")

            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.top, 8)
                    .frame(height: 35, alignment: .top)
                    .accessibilityIdentifier("detailStatusLoading")
            } else if let isOpen = isOpen {
                Text(isOpen ? "Open" : "Closed")
                    .font(.helvetica(size: 18))
                    .foregroundColor(isOpen ? Color.positive : Color.negative)
                    .padding(.top, 8)
                    .frame(height: 35, alignment: .top)
                    .accessibilityIdentifier("detailRestaurantStatus")
            } else {
                Text("Status unavailable")
                    .font(.helvetica(size: 18))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .frame(height: 35, alignment: .top)
                    .accessibilityIdentifier("detailRestaurantStatus")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aspectRatio(343/144, contentMode: .fit)
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 20)
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
