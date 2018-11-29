//
//  FlickrPhotoTests.swift
//  FlickrPhotoTests
//
//  Created by Zoheb Ahmed on 11/25/18.
//  Copyright © 2018 Zoheb Ahmed. All rights reserved.
//

import XCTest
@testable import FlickrPhoto

class FlickrPhotoListingViewModelTests: XCTestCase {
    var mockAPICommunicator: MockAPICommunicator!
    var sut: FlickrPhotoListingViewModel!
    override func setUp() {
        super.setUp()
        mockAPICommunicator = MockAPICommunicator()
        sut = FlickrPhotoListingViewModel(apiCommunicator: mockAPICommunicator)
    }

    override func tearDown() {
        sut = nil
        mockAPICommunicator = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func test_photo_fetch() {
        sut.fetchPhotos(itemName: "Kittens")
        // Assert
        XCTAssert(mockAPICommunicator!.isFetchPhotoCalled)
    }
    func test_photo_fetch_loading() {
        sut.fetchPhotos(itemName: "Kittens")
        if let viewState = sut.viewState {
            switch viewState {
            case .error(let errorStr):
                XCTAssertTrue(false, "Unexpected View State when fetching photos with error \(errorStr)")
            case .loading:
                XCTAssertTrue(true, "View Successfully transitioned to Loading State when fetching photos")
            case .photosAvailable:
                XCTAssertTrue(false, "Unexpected View State")
            }
        } else {
            XCTAssertTrue(false, "View State is not set")
        }
    }
    func test_photo_fetch_fail() {
        sut.fetchPhotos(itemName: "Kittens")
        let errorString = "Auth Error"
        mockAPICommunicator.fetchFail(error: errorString)
        if let viewState = sut.viewState {
            switch viewState {
            case .error(let errorStr):
                 XCTAssertEqual( errorStr, errorString)
            case .loading:
                XCTAssertTrue(false, "Unexpected View State")
            case .photosAvailable:
                 XCTAssertTrue(false, "Unexpected View State")
            }
        } else {
            XCTAssertTrue(false, "View State is not set")
        }
    }
    func test_photo_fetch_success() {
        sut.fetchPhotos(itemName: "Kittens")
        mockAPICommunicator.fetchSuccess()
        if let viewState = sut.viewState {
            switch viewState {
            case .error(let errorStr):
               XCTAssertTrue(false, "Unexpected View State - Error with \(errorStr)")
            case .loading:
                XCTAssertTrue(false, "Unexpected View State")
            case .photosAvailable:
                XCTAssertTrue(true, "View Successfully transitioned to photosAvailable State when fetching photos")
            }
        } else {
            XCTAssertTrue(false, "View State is not set")
        }
    }
    func test_photo_fetch_count() {
        sut.fetchPhotos(itemName: "Kittens")
        mockAPICommunicator.fetchSuccess()
        XCTAssertEqual(sut.photos?.count, 95)
    }
}
class MockAPICommunicator: APICommunicatorProtocol {
    var isFetchPhotoCalled = false
    var completeClosure: ((Dictionary<String, AnyObject>?, String?) -> Void)!
    
    func searchForItem(itemName name: String, pageNo: Int, completionHandler: @escaping (Dictionary<String, AnyObject>?, String?) -> Void) {
        isFetchPhotoCalled = true
        completeClosure = completionHandler
    }
    
    func fetchSuccess() {
        if let responseDict = StubGenerator().stubPhotosDict() {
            completeClosure(responseDict, nil)
        } else {
            fatalError("Invalid data from json file")
        }
    }
    
    func fetchFail(error: String) {
        completeClosure(nil, error)
    }
    
    func downloadImage(url: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
    }
}
class StubGenerator {
    func stubPhotosDict() -> [String: AnyObject]? {
        guard let path = Bundle(for: type(of: self)).path(forResource: "Kittens", ofType: "json") else {
            fatalError("Invalid path for json file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid data from json file")
        }
        guard  let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            fatalError("Invalid data from json file")
        }
        return responseDict
    }
}
