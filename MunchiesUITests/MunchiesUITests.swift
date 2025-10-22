//
//  MunchiesUITests.swift
//  MunchiesUITests
//
//  Created by Brad Woodard on 10/21/25.
//

import XCTest

final class MunchiesUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - RestaurantCardView Layout Tests

    @MainActor
    func testRestaurantCardView_DisplaysAllRequiredElements() throws {
        // Wait for the app to load data
        let firstRestaurantName = app.staticTexts["restaurantName"].firstMatch
        XCTAssertTrue(firstRestaurantName.waitForExistence(timeout: 5),
                     "Restaurant name should appear after data loads")

        // Verify restaurant name exists and is visible
        XCTAssertTrue(firstRestaurantName.exists, "Restaurant name should be displayed")
        XCTAssertTrue(firstRestaurantName.isHittable, "Restaurant name should be visible on screen")

        // Verify rating exists (now an accessibility element)
        let rating = app.descendants(matching: .any)["restaurantRating"].firstMatch
        XCTAssertTrue(rating.exists, "Restaurant rating should be displayed")

        // Verify filter tags exist
        let filters = app.staticTexts["restaurantFilters"].firstMatch
        XCTAssertTrue(filters.exists, "Restaurant filter tags should be displayed")

        // Verify delivery time exists (now an accessibility element)
        let deliveryTime = app.descendants(matching: .any)["restaurantDeliveryTime"].firstMatch
        XCTAssertTrue(deliveryTime.exists, "Restaurant delivery time should be displayed")
    }

    @MainActor
    func testRestaurantCardView_LayoutOrder() throws {
        // Wait for the first restaurant card to load
        let firstRestaurantName = app.staticTexts["restaurantName"].firstMatch
        XCTAssertTrue(firstRestaurantName.waitForExistence(timeout: 5),
                     "Restaurant name should appear after data loads")

        // Get the frames to verify vertical layout order
        let nameFrame = firstRestaurantName.frame
        let filtersFrame = app.staticTexts["restaurantFilters"].firstMatch.frame
        let deliveryTimeFrame = app.descendants(matching: .any)["restaurantDeliveryTime"].firstMatch.frame

        // Verify elements are stacked vertically in correct order
        XCTAssertLessThan(nameFrame.midY, filtersFrame.midY,
                         "Restaurant name should be above filter tags")
        XCTAssertLessThan(filtersFrame.midY, deliveryTimeFrame.midY,
                         "Filter tags should be above delivery time")
    }

    // MARK: - RestaurantDetailCard Layout Tests

    @MainActor
    func testRestaurantDetailCard_DisplaysAllRequiredElements() throws {
        // Wait for restaurants to load
        let firstRestaurantName = app.staticTexts["restaurantName"].firstMatch
        XCTAssertTrue(firstRestaurantName.waitForExistence(timeout: 5),
                     "Restaurant name should appear after data loads")

        // Tap on the first restaurant card to open detail view
        firstRestaurantName.tap()

        // Wait for detail view to appear
        let detailName = app.staticTexts["detailRestaurantName"]
        XCTAssertTrue(detailName.waitForExistence(timeout: 3),
                     "Detail restaurant name should appear")

        // Verify all detail elements exist
        XCTAssertTrue(detailName.exists, "Detail restaurant name should be displayed")

        let detailFilters = app.staticTexts["detailRestaurantFilters"]
        XCTAssertTrue(detailFilters.exists, "Detail filter tags should be displayed")

        // Status should exist (either loading indicator or status text)
        let statusExists = app.staticTexts["detailRestaurantStatus"].exists ||
                          app.activityIndicators["detailStatusLoading"].exists
        XCTAssertTrue(statusExists, "Restaurant status or loading indicator should be displayed")
    }

    @MainActor
    func testRestaurantDetailCard_LayoutOrder() throws {
        // Wait for restaurants to load
        let firstRestaurantName = app.staticTexts["restaurantName"].firstMatch
        XCTAssertTrue(firstRestaurantName.waitForExistence(timeout: 5),
                     "Restaurant name should appear after data loads")

        // Tap on the first restaurant to open detail view
        firstRestaurantName.tap()

        // Wait for detail view elements
        let detailName = app.staticTexts["detailRestaurantName"]
        XCTAssertTrue(detailName.waitForExistence(timeout: 3),
                     "Detail restaurant name should appear")

        let detailFilters = app.staticTexts["detailRestaurantFilters"]

        // Get frames to verify vertical layout order
        let nameFrame = detailName.frame
        let filtersFrame = detailFilters.frame

        // Verify elements are stacked vertically in correct order
        XCTAssertLessThan(nameFrame.midY, filtersFrame.midY,
                         "Restaurant name should be above filter tags in detail view")

        // Verify status is below filters (if it has finished loading)
        let status = app.staticTexts["detailRestaurantStatus"].firstMatch
        if status.waitForExistence(timeout: 3) {
            XCTAssertLessThan(filtersFrame.midY, status.frame.midY,
                             "Filter tags should be above status")
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        // Note: First run will show "No baseline average for Duration (AppLaunch)." warning - this is expected.
        // After the first run, Xcode establishes a baseline for comparison.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
