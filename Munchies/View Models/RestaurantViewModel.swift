//
//  RestaurantViewModel.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

@Observable
final class RestaurantViewModel {
    var restaurants: [Restaurant] = []
    var filters: [Filter] = []
    var selectedFilterIds: Set<String> = []
    var isLoading = true
    var errorMessage: String?

    private let restaurantFetcher: RestaurantFetching
    private let filterFetcher: FilterFetching

    var filteredRestaurants: [Restaurant] {
        guard !selectedFilterIds.isEmpty else {
            return restaurants
        }

        return restaurants.filter { restaurant in
            selectedFilterIds.isSubset(of: restaurant.filterIds)
        }
    }

    init(
        restaurantFetcher: RestaurantFetching = NetworkService(),
        filterFetcher: FilterFetching = NetworkService()
    ) {
        self.restaurantFetcher = restaurantFetcher
        self.filterFetcher = filterFetcher
    }

    @MainActor
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedRestaurants = try await restaurantFetcher.fetchRestaurants()
            restaurants = fetchedRestaurants

            let allFilterIds = Set(fetchedRestaurants.flatMap { $0.filterIds })
            let fetchedFilters = try await filterFetcher.fetchFilters(ids: Array(allFilterIds))
            filters = fetchedFilters.sorted(by: { $0.name > $1.name })

        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func toggleFilter(_ filterId: String) {
        if selectedFilterIds.contains(filterId) {
            selectedFilterIds.remove(filterId)
        } else {
            selectedFilterIds.insert(filterId)
        }
    }

    func isFilterSelected(_ filterId: String) -> Bool {
        selectedFilterIds.contains(filterId)
    }

    func clearFilters() {
        selectedFilterIds.removeAll()
    }
}
