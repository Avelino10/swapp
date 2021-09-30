//
//  RemoteStarWarsLoaderTests.swift
//  SwappTests
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation
import XCTest

class RemoteStarWarsLoader {}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteStarWarsLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteStarWarsLoader()

        XCTAssertNil(client.requestedURL)
    }
}
