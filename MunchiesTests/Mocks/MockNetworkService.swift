//
//  MockNetworkService.swift
//  MunchiesTests
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation
@testable import Munchies

/// Mock implementation of network protocols for testing
/// Allows control over success/failure scenarios and returned data
final class MockNetworkService: RestaurantFetching, FilterFetching, StatusFetching {

    // MARK: - Configuration Properties

    var shouldThrowError = false
    var errorToThrow: Error = URLError(.badServerResponse)

    var restaurantsToReturn: [Restaurant] = []
    var filtersToReturn: [Filter] = []
    var statusToReturn: RestaurantStatus?

    // MARK: - Tracking Properties (for verification)

    var fetchRestaurantsCalled = false
    var fetchFilterCalled = false
    var fetchFiltersCalled = false
    var fetchRestaurantStatusCalled = false
    var lastFetchedFilterId: String?
    var lastFetchedStatusId: String?

    // MARK: - RestaurantFetching

    func fetchRestaurants() async throws -> [Restaurant] {
        fetchRestaurantsCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        return restaurantsToReturn
    }

    // MARK: - FilterFetching

    func fetchFilter(id: String) async throws -> Filter {
        fetchFilterCalled = true
        lastFetchedFilterId = id

        if shouldThrowError {
            throw errorToThrow
        }

        guard let filter = filtersToReturn.first(where: { $0.id == id }) else {
            throw URLError(.badURL)
        }

        return filter
    }

    func fetchFilters(ids: [String]) async throws -> [Filter] {
        fetchFiltersCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        return filtersToReturn.filter { ids.contains($0.id) }
    }

    // MARK: - StatusFetching

    func fetchRestaurantStatus(id: String) async throws -> RestaurantStatus {
        fetchRestaurantStatusCalled = true
        lastFetchedStatusId = id

        if shouldThrowError {
            throw errorToThrow
        }

        guard let status = statusToReturn else {
            throw URLError(.badServerResponse)
        }

        return status
    }

    // MARK: - Helper Methods

    func reset() {
        shouldThrowError = false
        restaurantsToReturn = []
        filtersToReturn = []
        statusToReturn = nil
        fetchRestaurantsCalled = false
        fetchFilterCalled = false
        fetchFiltersCalled = false
        fetchRestaurantStatusCalled = false
        lastFetchedFilterId = nil
        lastFetchedStatusId = nil
    }
}
