//
//  RestaurantViewModelTests.swift
//  MunchiesTests
//
//  Created by Brad Woodard on 10/21/25.
//

import XCTest
@testable import Munchies

@MainActor
final class RestaurantViewModelTests: XCTestCase {

    var viewModel: RestaurantViewModel!
    var mockRestaurantFetcher: MockNetworkService!
    var mockFilterFetcher: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockRestaurantFetcher = MockNetworkService()
        mockFilterFetcher = MockNetworkService()
        viewModel = RestaurantViewModel(
            restaurantFetcher: mockRestaurantFetcher,
            filterFetcher: mockFilterFetcher
        )
    }

    override func tearDown() {
        viewModel = nil
        mockRestaurantFetcher = nil
        mockFilterFetcher = nil
        super.tearDown()
    }

    // MARK: - Load Data Tests

    func testLoadData_Success_LoadsRestaurantsAndFilters() async {
        // Given
        mockRestaurantFetcher.restaurantsToReturn = TestData.allRestaurants
        mockFilterFetcher.filtersToReturn = TestData.allFilters

        // When
        await viewModel.loadData()

        // Then
        XCTAssertTrue(mockRestaurantFetcher.fetchRestaurantsCalled, "Should fetch restaurants")
        XCTAssertTrue(mockFilterFetcher.fetchFiltersCalled, "Should fetch filters")
        XCTAssertEqual(viewModel.restaurants.count, 3, "Should load 3 restaurants")
        XCTAssertEqual(viewModel.filters.count, 3, "Should load 3 filters")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message")
    }

    func testLoadData_Failure_SetsErrorMessage() async {
        // Given
        mockRestaurantFetcher.shouldThrowError = true
        mockRestaurantFetcher.errorToThrow = URLError(.notConnectedToInternet)

        // When
        await viewModel.loadData()

        // Then
        XCTAssertTrue(mockRestaurantFetcher.fetchRestaurantsCalled, "Should attempt to fetch")
        XCTAssertNotNil(viewModel.errorMessage, "Should set error message")
        XCTAssertTrue(viewModel.restaurants.isEmpty, "Should have no restaurants on error")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after error")
    }

    func testLoadData_SortsFiltersByName() async {
        // Given
        let unsortedFilters = [
            Filter(id: "filter-3", name: "Zebra", imageURL: URL(string: "https://example.com")!),
            Filter(id: "filter-1", name: "Apple", imageURL: URL(string: "https://example.com")!),
            Filter(id: "filter-2", name: "Banana", imageURL: URL(string: "https://example.com")!)
        ]
        mockRestaurantFetcher.restaurantsToReturn = TestData.allRestaurants
        mockFilterFetcher.filtersToReturn = unsortedFilters

        // When
        await viewModel.loadData()

        // Then
        XCTAssertEqual(viewModel.filters.map { $0.name }, ["Zebra", "Banana", "Apple"],
                       "Filters should be sorted in descending order by name")
    }

    // MARK: - Filter Selection Tests

    func testToggleFilter_AddsFilterToSelection() {
        // Given
        let filterId = "filter-1"

        // When
        viewModel.toggleFilter(filterId)

        // Then
        XCTAssertTrue(viewModel.isFilterSelected(filterId), "Filter should be selected")
        XCTAssertEqual(viewModel.selectedFilterIds.count, 1, "Should have 1 selected filter")
    }

    func testToggleFilter_RemovesFilterFromSelection() {
        // Given
        let filterId = "filter-1"
        viewModel.toggleFilter(filterId) // Add it first

        // When
        viewModel.toggleFilter(filterId) // Toggle again to remove

        // Then
        XCTAssertFalse(viewModel.isFilterSelected(filterId), "Filter should not be selected")
        XCTAssertTrue(viewModel.selectedFilterIds.isEmpty, "Should have no selected filters")
    }

    func testClearFilters_RemovesAllSelections() {
        // Given
        viewModel.toggleFilter("filter-1")
        viewModel.toggleFilter("filter-2")
        viewModel.toggleFilter("filter-3")

        // When
        viewModel.clearFilters()

        // Then
        XCTAssertTrue(viewModel.selectedFilterIds.isEmpty, "All filters should be cleared")
    }

    // MARK: - Filtered Restaurants Tests

    func testFilteredRestaurants_NoFiltersSelected_ReturnsAllRestaurants() async {
        // Given
        mockRestaurantFetcher.restaurantsToReturn = TestData.allRestaurants
        mockFilterFetcher.filtersToReturn = TestData.allFilters
        await viewModel.loadData()

        // When
        let filtered = viewModel.filteredRestaurants

        // Then
        XCTAssertEqual(filtered.count, 3, "Should return all restaurants when no filters selected")
    }

    func testFilteredRestaurants_OneFilterSelected_ReturnsMatchingRestaurants() async {
        // Given
        mockRestaurantFetcher.restaurantsToReturn = TestData.allRestaurants
        mockFilterFetcher.filtersToReturn = TestData.allFilters
        await viewModel.loadData()

        // When
        viewModel.toggleFilter("filter-1") // All restaurants have this
        let filtered = viewModel.filteredRestaurants

        // Then
        XCTAssertEqual(filtered.count, 3, "All 3 restaurants have filter-1")
    }

    func testFilteredRestaurants_MultipleFilters_RequiresAllFilters() async {
        // Given
        mockRestaurantFetcher.restaurantsToReturn = TestData.allRestaurants
        mockFilterFetcher.filtersToReturn = TestData.allFilters
        await viewModel.loadData()

        // When
        viewModel.toggleFilter("filter-1") // All restaurants have this
        viewModel.toggleFilter("filter-2") // Only 2 restaurants have both filter-1 AND filter-2
        let filtered = viewModel.filteredRestaurants

        // Then
        XCTAssertEqual(filtered.count, 2, "Only 2 restaurants have both filter-1 AND filter-2")
        XCTAssertTrue(filtered.contains(where: { $0.id == "rest-1" }), "Should include rest-1")
        XCTAssertTrue(filtered.contains(where: { $0.id == "rest-2" }), "Should include rest-2")
        XCTAssertFalse(filtered.contains(where: { $0.id == "rest-3" }), "Should NOT include rest-3")
    }

    func testFilteredRestaurants_ThreeFilters_RequiresAllThree() async {
        // Given
        mockRestaurantFetcher.restaurantsToReturn = TestData.allRestaurants
        mockFilterFetcher.filtersToReturn = TestData.allFilters
        await viewModel.loadData()

        // When
        viewModel.toggleFilter("filter-1")
        viewModel.toggleFilter("filter-2")
        viewModel.toggleFilter("filter-3") // Only 1 restaurant has all three
        let filtered = viewModel.filteredRestaurants

        // Then
        XCTAssertEqual(filtered.count, 1, "Only 1 restaurant has all three filters")
        XCTAssertEqual(filtered.first?.id, "rest-1", "Should only include rest-1")
    }
}
