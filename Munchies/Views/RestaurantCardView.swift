//
//  RestaurantCardView.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    let filters: [Filter]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Restaurant Image
            AsyncImage(url: restaurant.imageURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 120)
            .clipped()

            // Restaurant Info
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .top) {
                    Text(restaurant.name)
                        .font(.helvetica(size: 18))
                        .foregroundStyle(Color.darkText)
                        .lineLimit(2)
                        .padding(.leading, 8)
                        .accessibilityIdentifier("restaurantName")

                    Spacer(minLength: 8)

                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.star)
                            .font(.system(size: 12))
                        Text(String(format: "%.1f", restaurant.rating))
                            .foregroundStyle(Color.ratingText)
                            .font(.inter(size: 10))
                    }
                    .fixedSize()
                    .padding(.trailing, 8)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Rating \(String(format: "%.1f", restaurant.rating))")
                    .accessibilityIdentifier("restaurantRating")
                }

                // Filter tags
                Text(restaurant.filterTagsText(from: filters))
                    .font(.helveticaBold(size: 12))
                    .foregroundStyle(Color.subtitle)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .accessibilityIdentifier("restaurantFilters")

                // Delivery Time
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundStyle(Color(hex: "ff5252"))
                        .font(.system(size: 10))
                    Text(deliveryTimeText)
                        .font(.inter(size: 10))
                        .foregroundStyle(Color(hex: "50555c"))
                }
                .padding(.horizontal, 8)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Delivery time \(deliveryTimeText)")
                .accessibilityIdentifier("restaurantDeliveryTime")
            }
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12,
                style: .continuous
            )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    private var deliveryTimeText: String {
        let minutes = restaurant.deliveryTimeMinutes
        if minutes >= 60 {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return hours == 1 ? "1 hour" : "\(hours) hours"
            } else {
                return "\(hours) hour \(remainingMinutes) mins"
            }
        } else {
            return minutes == 1 ? "1 min" : "\(minutes) mins"
        }
    }
}

#Preview {
    RestaurantCardView(restaurant: .mock, filters: Filter.mockFilters)
        .padding()
}
