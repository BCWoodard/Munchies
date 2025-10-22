//
//  RestaurantStatus.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

struct RestaurantStatus: Decodable {
    let isCurrentlyOpen: Bool
    let restaurantId: String

    enum CodingKeys: String, CodingKey {
        case isCurrentlyOpen = "is_currently_open"
        case restaurantId = "restaurant_id"
    }
}
