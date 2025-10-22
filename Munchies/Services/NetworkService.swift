//
//  NetworkService.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

struct NetworkService: NetworkServiceProtocol {
    var baseURL: URL = URL(string: "https://food-delivery.umain.io/api/v1")!

    private struct RestaurantsResponse: Decodable {
        let restaurants: [Restaurant]
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    func fetchRestaurants() async throws -> [Restaurant] {
        let endpoint = baseURL.appending(path: "/restaurants")
        let (data, response) = try await URLSession.shared.data(from: endpoint)

        try validateResponse(response)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        let wrapper = try decoder.decode(RestaurantsResponse.self, from: data)
        return wrapper.restaurants
    }

    func fetchFilter(id: String) async throws -> Filter {
        let endpoint = baseURL.appending(path: "/filter/\(id)")
        let (data, response) = try await URLSession.shared.data(from: endpoint)

        try validateResponse(response)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        return try decoder.decode(Filter.self, from: data)
    }

    func fetchFilters(ids: [String]) async throws -> [Filter] {
        try await withThrowingTaskGroup(of: Filter.self) { group in
            for id in ids {
                group.addTask {
                    try await fetchFilter(id: id)
                }
            }

            var filters: [Filter] = []
            for try await filter in group {
                filters.append(filter)
            }
            return filters
        }
    }

    func fetchRestaurantStatus(id: String) async throws -> RestaurantStatus {
        let endpoint = baseURL.appending(path: "/open/\(id)")
        let (data, response) = try await URLSession.shared.data(from: endpoint)

        try validateResponse(response)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        return try decoder.decode(RestaurantStatus.self, from: data)
    }
}
