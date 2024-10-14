import XCTest
@testable import FetchApp

class FetchAppTests: XCTestCase {
    var viewModel: HomeViewModel!
    var testData: [FetchData]!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = HomeViewModel()
        testData = [
            FetchData(id: 1, listID: 2, name: "Apple"),
            FetchData(id: 2, listID: 1, name: "Banana"),
            FetchData(id: 3, listID: 2, name: "null"),
            FetchData(id: 4, listID: 1, name: ""),
            FetchData(id: 5, listID: 1, name: "Cherry"),
            FetchData(id: 6, listID: 2, name: nil)
        ]
        viewModel.processData(testData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    func testViewModelInitialization() {
        XCTAssertNotNil(viewModel, "ViewModel should be initialized")
    }

    func testListIDGrouping() {
        let expectedGroupKeys = [1, 2]
        let groupKeys = Array(viewModel.groupedAndSortedData.keys).sorted()
        XCTAssertEqual(groupKeys, expectedGroupKeys, "Group keys should match expected list IDs")
    }

    func testNameSortingWithinGroups() {
        let expectedNamesForListID1 = ["Banana", "Cherry"]
        let namesForListID1 = viewModel.groupedAndSortedData[1]?.map { $0.name ?? "" }
        XCTAssertEqual(namesForListID1, expectedNamesForListID1, "Names for ListID 1 should be sorted alphabetically")

        let expectedNamesForListID2 = ["Apple","null"]
        let namesForListID2 = viewModel.groupedAndSortedData[2]?.map { $0.name ?? "" }
        XCTAssertEqual(namesForListID2, expectedNamesForListID2, "Names for ListID 2 should be sorted alphabetically")
    }

    func testFilteringInvalidNames() {
        let totalValidItems = viewModel.groupedAndSortedData.values.flatMap { $0 }.count
        XCTAssertEqual(totalValidItems, 4, "Should only include 4 valid names")
    }

    func testEmptyAndNullNameExclusion() {
        XCTAssertFalse(viewModel.groupedAndSortedData[2]?.contains(where: { $0.name == "" || $0.name == nil  }) ?? true, "Invalid names should be excluded")
    }
}
