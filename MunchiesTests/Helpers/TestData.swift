//
//  TestData.swift
//  MunchiesTests
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation
@testable import Munchies

/// Centralized test data for consistent test fixtures
enum TestData {

    // MARK: - Filters

    static let filterTopRated = Filter(
        id: "filter-1",
        name: "Top Rated",
        imageURL: URL(string: "https://example.com/top-rated.png")!
    )

    static let filterFastDelivery = Filter(
        id: "filter-2",
        name: "Fast Delivery",
        imageURL: URL(string: "https://example.com/fast-delivery.png")!
    )

    static let filterEatIn = Filter(
        id: "filter-3",
        name: "Eat-In",
        imageURL: URL(string: "https://example.com/eat-in.png")!
    )

    static let allFilters = [filterTopRated, filterFastDelivery, filterEatIn]

    // MARK: - Restaurants

    static let restaurantWithAllFilters = Restaurant(
        id: "rest-1",
        name: "Great Food Place",
        rating: 4.5,
        imageURL: URL(string: "https://example.com/restaurant1.png")!,
        deliveryTimeMinutes: 30,
        filterIds: ["filter-1", "filter-2", "filter-3"]
    )

    static let restaurantWithTwoFilters = Restaurant(
        id: "rest-2",
        name: "Pizza Palace",
        rating: 4.2,
        imageURL: URL(string: "https://example.com/restaurant2.png")!,
        deliveryTimeMinutes: 25,
        filterIds: ["filter-1", "filter-2"]
    )

    static let restaurantWithOneFilter = Restaurant(
        id: "rest-3",
        name: "Burger Bar",
        rating: 3.8,
        imageURL: URL(string: "https://example.com/restaurant3.png")!,
        deliveryTimeMinutes: 20,
        filterIds: ["filter-1"]
    )

    static let allRestaurants = [
        restaurantWithAllFilters,
        restaurantWithTwoFilters,
        restaurantWithOneFilter
    ]

    // MARK: - Restaurant Status

    static let statusOpen = RestaurantStatus(
        isCurrentlyOpen: true,
        restaurantId: "rest-1"
    )

    static let statusClosed = RestaurantStatus(
        isCurrentlyOpen: false,
        restaurantId: "rest-1"
    )
}
