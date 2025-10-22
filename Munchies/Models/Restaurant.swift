//
//  Restaurant.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

struct Restaurant: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let rating: Double
    let imageURL: URL
    let deliveryTimeMinutes: Int
    let filterIds: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rating
        case imageURL = "image_url"
        case deliveryTimeMinutes = "delivery_time_minutes"
        case filterIds
    }
}

extension Restaurant {
    func filterTagsText(from filters: [Filter]) -> String {
        let restaurantFilters = filters.filter { filterIds.contains($0.id) }
        let names = restaurantFilters.map { $0.name }
        return names.joined(separator: " • ")
    }
}

#if DEBUG
extension Restaurant {
    static let mock = Restaurant(
        id: "7450001",
        name: #"Wayne "Chad Broski" Burgers"#,
        rating: 4.6,
        imageURL: URL(string: "https://food-delivery.umain.io/images/restaurant/burgers.png")!,
        deliveryTimeMinutes: 9,
        filterIds: [
            "5c64dea3-a4ac-4151-a2e3-42e7919a925d",
            "614fd642-3fa6-4f15-8786-dd3a8358cd78",
            "c67cd8a3-f191-4083-ad28-741659f214d7",
            "23a38556-779e-4a3b-a75b-fcbc7a1c7a20"
        ]
    )
}
#endif
