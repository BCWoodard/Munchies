//
//  RestaurantDetailView.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    let filters: [Filter]

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RestaurantDetailViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Background
                Color.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Image Section with Dismiss Button Overlay
                    ZStack(alignment: .topLeading) {
                        // Restaurant Image (maintaining 375:220 aspect ratio)
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
                                    .aspectRatio(375/220, contentMode: .fill)
                            case .failure:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .overlay {
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 48))
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(375/220, contentMode: .fit)
                        .clipped()

                        // Dismiss Button (downward caret)
                        VStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.darkText)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .white.opacity(0.25), radius: 4, x: 0, y: 4)
                            }
                            .padding(.top, 24)
                            .padding(.leading)
                            Spacer()
                        }
                        .padding(.top)
                    }
                    Spacer()
                }

                // Info Card positioned to align with bottom of image
                RestaurantDetailCard(
                    restaurant: restaurant,
                    filters: filters,
                    isOpen: viewModel.isOpen,
                    isLoading: viewModel.isLoading
                )
                .padding(.horizontal, 16)
                .position(x: geometry.size.width / 2, y: (geometry.size.width * (220.0/375.0) + 24))
            }
            .ignoresSafeArea(edges: [.top, .bottom])
        }
        .statusBar(hidden: true)
        .task {
            await viewModel.loadRestaurantStatus()
        }
    }

    init(restaurant: Restaurant, filters: [Filter]) {
        self.restaurant = restaurant
        self.filters = filters
        _viewModel = State(initialValue: RestaurantDetailViewModel(restaurantId: restaurant.id))
    }
}

#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: .mock, filters: Filter.mockFilters)
    }
}
