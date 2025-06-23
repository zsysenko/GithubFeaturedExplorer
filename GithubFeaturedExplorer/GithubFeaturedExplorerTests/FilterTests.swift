//
//  FilterTests.swift
//  GithubFeaturedExplorerTests
//
//  Created by EVGENY SYSENKA on 23/06/2025.
//

import XCTest
@testable import GithubFeaturedExplorer

final class FilterTests: XCTestCase {

    private var objects = ["Object Green", "Object Red"]
    
    func testFilter_InitialSelection() {
        let object1 = "Object Green"
        let object2 = "Object Red"
        let sut = FiltersViewModel(
            objects: [object1, object2],
            selectedObject: object1
        )
        
        XCTAssertEqual(sut.selectedObject, object1)
    }
    
    func testFilter_Selection() {
        let object1 = "Object Green"
        let object2 = "Object Red"
        let sut = FiltersViewModel(
            objects: [object1, object2],
            selectedObject: object1
        )
        
        sut.selectedObject = object2
        
        XCTAssertEqual(sut.selectedObject, object2)
    }
    
    func testFilter_SelectionNil() {
        let object1 = "Object Green"
        let object2 = "Object Red"
        let sut = FiltersViewModel(
            objects: [object1, object2],
            selectedObject: object1,
            isOptionalAvailable: true
        )
        
        sut.selectedObject = nil
        
        XCTAssertNil(sut.selectedObject)
    }
}
