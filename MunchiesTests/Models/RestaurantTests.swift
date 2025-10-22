//
//  RestaurantTests.swift
//  MunchiesTests
//
//  Created by Brad Woodard on 10/21/25.
//

import XCTest
@testable import Munchies

final class RestaurantTests: XCTestCase {

    // MARK: - filterTagsText Tests

    func testFilterTagsText_NoMatchingFilters_ReturnsEmptyString() {
        // Given
        let restaurant = Restaurant(
            id: "rest-1",
            name: "Test Restaurant",
            rating: 4.0,
            imageURL: URL(string: "https://example.com")!,
            deliveryTimeMinutes: 30,
            filterIds: ["non-existent-filter"]
        )
        let filters: [Filter] = []

        // When
        let result = restaurant.filterTagsText(from: filters)

        // Then
        XCTAssertEqual(result, "", "Should return empty string when no filters match")
    }

    func testFilterTagsText_OneMatchingFilter_ReturnsSingleName() {
        // Given
        let restaurant = TestData.restaurantWithOneFilter
        let filters = [TestData.filterTopRated]

        // When
        let result = restaurant.filterTagsText(from: filters)

        // Then
        XCTAssertEqual(result, "Top Rated", "Should return single filter name")
    }

    func testFilterTagsText_MultipleMatchingFilters_ReturnsJoinedWithBullets() {
        // Given
        let restaurant = TestData.restaurantWithTwoFilters
        let filters = [TestData.filterTopRated, TestData.filterFastDelivery]

        // When
        let result = restaurant.filterTagsText(from: filters)

        // Then
        XCTAssertTrue(result.contains("Top Rated"), "Should contain first filter name")
        XCTAssertTrue(result.contains("Fast Delivery"), "Should contain second filter name")
        XCTAssertTrue(result.contains(" • "), "Should join with bullet separator")
    }

    func testFilterTagsText_AllFiltersMatch_ReturnsAllNames() {
        // Given
        let restaurant = TestData.restaurantWithAllFilters
        let filters = TestData.allFilters

        // When
        let result = restaurant.filterTagsText(from: filters)

        // Then
        XCTAssertTrue(result.contains("Top Rated"), "Should contain Top Rated")
        XCTAssertTrue(result.contains("Fast Delivery"), "Should contain Fast Delivery")
        XCTAssertTrue(result.contains("Eat-In"), "Should contain Eat-In")

        let bulletCount = result.components(separatedBy: " • ").count - 1
        XCTAssertEqual(bulletCount, 2, "Should have 2 bullet separators for 3 items")
    }

    func testFilterTagsText_PartialFilterMatch_ReturnsOnlyMatchingFilters() {
        // Given
        let restaurant = TestData.restaurantWithTwoFilters // Has filter-1 and filter-2
        let filters = TestData.allFilters // Includes filter-1, filter-2, filter-3

        // When
        let result = restaurant.filterTagsText(from: filters)

        // Then
        XCTAssertTrue(result.contains("Top Rated"), "Should contain Top Rated (filter-1)")
        XCTAssertTrue(result.contains("Fast Delivery"), "Should contain Fast Delivery (filter-2)")
        XCTAssertFalse(result.contains("Eat-In"), "Should NOT contain Eat-In (filter-3)")
    }

    func testFilterTagsText_FiltersInDifferentOrder_ReturnsConsistentResult() {
        // Given
        let restaurant = TestData.restaurantWithTwoFilters
        let filters1 = [TestData.filterTopRated, TestData.filterFastDelivery]
        let filters2 = [TestData.filterFastDelivery, TestData.filterTopRated]

        // When
        let result1 = restaurant.filterTagsText(from: filters1)
        let result2 = restaurant.filterTagsText(from: filters2)

        // Then
        // Note: Order might differ based on filter array order, but both should contain same filters
        let components1 = Set(result1.components(separatedBy: " • "))
        let components2 = Set(result2.components(separatedBy: " • "))
        XCTAssertEqual(components1, components2, "Should contain same filters regardless of order")
    }
}
