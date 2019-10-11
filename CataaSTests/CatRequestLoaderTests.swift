//
//  CatRequestLoaderTests.swift
//  CataaSTests
//
//  Created by Thinh Vo on 11.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
@testable import CataaS


// swiftlint:disable force_cast
class CatRequestLoaderTests: XCTestCase {

    var sut: APIRequestLoader<CatRequest>!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)

        let config = APIConfiguration(baseURL: "https://test.com")
        let catRequest = CatRequest(configuration: config)

        sut = APIRequestLoader<CatRequest>(request: catRequest, session: session)
    }

    override func tearDown() {}

    func testLoadRequest_WithNotFoundError_ReceiveNotFoundError() {
        MockURLProtocol.handler = { _ in
            let httpURLResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                                  statusCode: 404,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (httpURLResponse!, Data())
        }

        let expect = expectation(description: "test")
        sut.loadRequest(requestData: nil) { (image, error) in
            XCTAssertNil(image, "The image must be nil when an error occurs")
            XCTAssertNotNil(error, "There must be an error")
            XCTAssertEqual(error as! APIRequestLoaderError, APIRequestLoaderError.notFound)
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testLoadRequest_WithNotFoundError_ReceiveUnknownError() {
        MockURLProtocol.handler = { _ in
            let httpURLResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                                  statusCode: 500,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (httpURLResponse!, Data())
        }

        let expect = expectation(description: "test")
        sut.loadRequest(requestData: nil) { (image, error) in
            XCTAssertNil(image, "The image must be nil when an error occurs")
            XCTAssertNotNil(error, "There must be an error")
            XCTAssertEqual(error as! APIRequestLoaderError, APIRequestLoaderError.unknown)
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    // Some more similar tests for the success case(valid responsed image) can be implemented here.
}
