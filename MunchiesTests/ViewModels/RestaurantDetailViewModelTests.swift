//
//  RestaurantDetailViewModelTests.swift
//  MunchiesTests
//
//  Created by Brad Woodard on 10/21/25.
//

import XCTest
@testable import Munchies

final class RestaurantDetailViewModelTests: XCTestCase {

    var viewModel: RestaurantDetailViewModel!
    var mockStatusFetcher: MockNetworkService!
    let testRestaurantId = "test-restaurant-123"

    override func setUp() {
        super.setUp()
        mockStatusFetcher = MockNetworkService()
        viewModel = RestaurantDetailViewModel(
            restaurantId: testRestaurantId,
            statusFetcher: mockStatusFetcher
        )
    }

    override func tearDown() {
        viewModel = nil
        mockStatusFetcher = nil
        super.tearDown()
    }

    // MARK: - Load Restaurant Status Tests

    func testLoadRestaurantStatus_Success_Open() async {
        // Given
        mockStatusFetcher.statusToReturn = TestData.statusOpen

        // When
        await viewModel.loadRestaurantStatus()

        // Then
        XCTAssertTrue(mockStatusFetcher.fetchRestaurantStatusCalled, "Should call fetch status")
        XCTAssertEqual(mockStatusFetcher.lastFetchedStatusId, testRestaurantId,
                       "Should fetch status for correct restaurant ID")
        XCTAssertEqual(viewModel.isOpen, true, "Should set isOpen to true")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message")
    }

    func testLoadRestaurantStatus_Success_Closed() async {
        // Given
        mockStatusFetcher.statusToReturn = TestData.statusClosed

        // When
        await viewModel.loadRestaurantStatus()

        // Then
        XCTAssertTrue(mockStatusFetcher.fetchRestaurantStatusCalled, "Should call fetch status")
        XCTAssertEqual(viewModel.isOpen, false, "Should set isOpen to false")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message")
    }

    func testLoadRestaurantStatus_Failure_SetsErrorMessage() async {
        // Given
        mockStatusFetcher.shouldThrowError = true
        mockStatusFetcher.errorToThrow = URLError(.notConnectedToInternet)

        // When
        await viewModel.loadRestaurantStatus()

        // Then
        XCTAssertTrue(mockStatusFetcher.fetchRestaurantStatusCalled, "Should attempt to fetch")
        XCTAssertNil(viewModel.isOpen, "Should set isOpen to nil on error")
        XCTAssertNotNil(viewModel.errorMessage, "Should set error message")
        XCTAssertEqual(viewModel.errorMessage, "Unable to load restaurant status",
                       "Should have specific error message")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after error")
    }

    func testLoadRestaurantStatus_SetsLoadingState() async {
        // Given
        mockStatusFetcher.statusToReturn = TestData.statusOpen

        // When - Check loading state before completion
        XCTAssertTrue(viewModel.isLoading, "Should start in loading state")

        await viewModel.loadRestaurantStatus()

        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }

    func testLoadRestaurantStatus_ClearsErrorMessageOnNewLoad() async {
        // Given - Set up initial error state
        mockStatusFetcher.shouldThrowError = true
        await viewModel.loadRestaurantStatus()
        XCTAssertNotNil(viewModel.errorMessage, "Should have error from first attempt")

        // When - Retry with success
        mockStatusFetcher.shouldThrowError = false
        mockStatusFetcher.statusToReturn = TestData.statusOpen
        await viewModel.loadRestaurantStatus()

        // Then
        XCTAssertNil(viewModel.errorMessage, "Should clear error message on successful retry")
        XCTAssertEqual(viewModel.isOpen, true, "Should have loaded status successfully")
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        // Then
        XCTAssertNil(viewModel.isOpen, "isOpen should start as nil")
        XCTAssertTrue(viewModel.isLoading, "Should start in loading state")
        XCTAssertNil(viewModel.errorMessage, "Should start with no error message")
    }
}
