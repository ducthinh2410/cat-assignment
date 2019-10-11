//
//  CatRequestTests.swift
//  CataaSTests
//
//  Created by Thinh Vo on 11.10.2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import XCTest
@testable import CataaS

// swiftlint:disable force_try
class CatRequestTests: XCTestCase {

    var configuration: APIConfiguration!
    var sut: CatRequest!

    override func setUp() {
        configuration = APIConfiguration(baseURL: "https://test.com")
        sut = CatRequest(configuration: configuration)
    }

    override func tearDown() {}

    func testCreatRequest_WithoutTag_HasCorrectURL() {
        let urlRequest = try! sut.createRequest(nil) // nil: no tag

        XCTAssertNotNil(urlRequest.url)
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://test.com/cat")
    }

    func testCatRequest_WithTag_HasCorrectURL() {
        let urlRequest = try! sut.createRequest("kitty")

        XCTAssertNotNil(urlRequest.url)
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://test.com/cat/kitty")
    }

    func testParseResponseData_WithValidImageData_ParseSuccess() {
        let imageData = UIImage(named: "placeholder")!.pngData()!

        let data = try! sut.parseResponse(imageData)
        XCTAssertNotNil(data)
    }
}
