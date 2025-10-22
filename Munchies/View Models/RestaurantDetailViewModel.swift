//
//  RestaurantDetailViewModel.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

@Observable
class RestaurantDetailViewModel {
    var isOpen: Bool?
    var isLoading = true
    var errorMessage: String?

    private let statusFetcher: StatusFetching
    private let restaurantId: String

    init(restaurantId: String, statusFetcher: StatusFetching = NetworkService()) {
        self.restaurantId = restaurantId
        self.statusFetcher = statusFetcher
    }

    func loadRestaurantStatus() async {
        isLoading = true
        errorMessage = nil

        do {
            let status = try await statusFetcher.fetchRestaurantStatus(id: restaurantId)
            isOpen = status.isCurrentlyOpen
        } catch {
            errorMessage = "Unable to load restaurant status"
            isOpen = nil
        }

        isLoading = false
    }
}
