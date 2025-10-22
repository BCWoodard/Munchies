//
//  NetworkProtocols.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

protocol RestaurantFetching {
    func fetchRestaurants() async throws -> [Restaurant]
}

protocol FilterFetching {
    func fetchFilter(id: String) async throws -> Filter
    func fetchFilters(ids: [String]) async throws -> [Filter]
}

protocol StatusFetching {
    func fetchRestaurantStatus(id: String) async throws -> RestaurantStatus
}

protocol NetworkServiceProtocol: RestaurantFetching, FilterFetching, StatusFetching {}
