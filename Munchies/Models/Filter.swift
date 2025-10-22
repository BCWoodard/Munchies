//
//  Filter.swift
//  Munchies
//
//  Created by Brad Woodard on 10/21/25.
//

import Foundation

struct Filter: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
    }
}

#if DEBUG
extension Filter {
    static let mock = Filter(
        id: "5c64dea3-a4ac-4151-a2e3-42e7919a925d",
        name: "Top Rated",
        imageURL: URL(string: "https://food-delivery.umain.io/images/filter/filter_top_rated.png")!
    )

    static let mockFilters = [
        Filter(
            id: "5c64dea3-a4ac-4151-a2e3-42e7919a925d",
            name: "Top Rated",
            imageURL: URL(string: "https://food-delivery.umain.io/images/filter/filter_top_rated.png")!
        ),
        Filter(
            id: "614fd642-3fa6-4f15-8786-dd3a8358cd78",
            name: "Fast food",
            imageURL: URL(string: "https://food-delivery.umain.io/images/filter/filter_fast_food.png")!
        ),
        Filter(
            id: "c67cd8a3-f191-4083-ad28-741659f214d7",
            name: "Take-Out",
            imageURL: URL(string: "https://food-delivery.umain.io/images/filter/filter_take_out.png")!
        )
    ]
}
#endif
