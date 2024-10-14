//
//  FetchAppTests.swift
//  FetchAppTests
//
//  Created by Jeet P Mehta on 13/10/24.
//
import XCTest
@testable import FetchApp

class FetchAppTests: XCTestCase {
    var viewModel: HomeViewModel!
    var testData: [FetchData]!

    // intiliases the needed components
    override func setUpWithError() throws {
        super.setUp()
        // Initializes the ViewModel.
        viewModel = HomeViewModel()
        // Prepares a set of test data to use in the tests.
        testData = [
            FetchData(id: 1, listID: 2, name: "Apple"),
            FetchData(id: 2, listID: 1, name: "Banana"),
            FetchData(id: 3, listID: 2, name: "null"), // a string "null", not a nil value.
            FetchData(id: 4, listID: 1, name: ""), //  an empty string.
            FetchData(id: 5, listID: 1, name: "Cherry"),
            FetchData(id: 6, listID: 2, name: nil) // representing no name.
        ]
        // simulate fetching and sorting.
        viewModel.processData(testData)
    }

    // cleans up and resets the environment after each test.
    override func tearDownWithError() throws {
        // clear the ViewModel after tests to prevent data leakage between tests.
        viewModel = nil
        super.tearDown()
    }

    // test to ensure that the ViewModel is correctly initialized.
    func testViewModelInitialization() {
        
        XCTAssertNotNil(viewModel, "The ViewModel should not be nil.")
    }

    // test to verify that items are correctly grouped by their list ID.
    func testListIDGrouping() {
        let expectedGroupKeys = [1, 2]
        // retrieves the list IDs from the viewModel and sorts them to ensure order.
        let groupKeys = Array(viewModel.groupedAndSortedData.keys).sorted()
        XCTAssertEqual(groupKeys, expectedGroupKeys, "The group keys should match the expected list.")
    }

    // test to verify that the names within each group are sorted alphabetically.
    func testNameSortingWithinGroups() {
        // define the expected sorted names for each list ID.
        let expectedNamesForListID1 = ["Banana", "Cherry"]
        let namesForListID1 = viewModel.groupedAndSortedData[1]?.map { $0.name ?? "No name" }
        XCTAssertEqual(namesForListID1, expectedNamesForListID1, "Names for ListID 1 should be sorted alphabetically.")
        let expectedNamesForListID2 = ["Apple", "null"]
        let namesForListID2 = viewModel.groupedAndSortedData[2]?.map { $0.name ?? "No name" }
        XCTAssertEqual(namesForListID2, expectedNamesForListID2, "Names for ListID 2 should be sorted alphabetically.")
    }

    func testFilteringInvalidNames() {
        let totalValidItems = viewModel.groupedAndSortedData.values.flatMap { $0 }.count
        // There should only be 4 valid items based on the test data, excluding empty and nil names.
        XCTAssertEqual(totalValidItems, 4, "There should only be 4 valid names included in the sorted data.")
    }

    // test to verify that no items with empty or nil names are included in the final data.
    func testEmptyAndNullNameExclusion() {
        // Check each group to ensure no entries have an empty or nil name.
        let containsInvalidNames = viewModel.groupedAndSortedData[2]?.contains(where: { $0.name == "" || $0.name == nil }) ?? false
        // Assert false to confirm there are no invalid names.
        XCTAssertFalse(containsInvalidNames, "Invalid names (empty or nil) should be ecxluded ")
    }
}
