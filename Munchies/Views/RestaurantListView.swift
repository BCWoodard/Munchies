//
//  RestaurantListview.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import SwiftUI

struct RestaurantListView: View {
    @State private var viewModel = RestaurantViewModel()
    @State private var selectedRestaurant: Restaurant?
    @State private var showContent = false

    var body: some View {
        NavigationStack {
            VStack(alignment: !viewModel.isLoading ? .leading : .center, spacing: 8) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .padding(.horizontal, !viewModel.isLoading ? 20 : 0)
                    .padding(.top, !viewModel.isLoading ? -8 : 0)
                    .frame(maxWidth: !viewModel.isLoading ? nil : .infinity)

                // Restaurant List
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.negative)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.loadData()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Spacer()
                } else {
                    // Filters Horizontal Scroll
                    if !viewModel.filters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.filters) { filter in
                                    FilterChipView(
                                        filter: filter,
                                        isSelected: viewModel.isFilterSelected(filter.id)
                                    ) {
                                        viewModel.toggleFilter(filter.id)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        }
                        .opacity(showContent ? 1 : 0)
                    }

                    // Restaurant List (scrollable)
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredRestaurants, id: \.id) { restaurant in
                                Button {
                                    selectedRestaurant = restaurant
                                } label: {
                                    RestaurantCardView(restaurant: restaurant, filters: viewModel.filters)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                    .opacity(showContent ? 1 : 0)
                    .padding(.top, 8)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.3).delay(0.3)) {
                            showContent = true
                        }
                    }
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.isLoading)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .fullScreenCover(item: $selectedRestaurant) { restaurant in
                RestaurantDetailView(restaurant: restaurant, filters: viewModel.filters)
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    RestaurantListView()
}
