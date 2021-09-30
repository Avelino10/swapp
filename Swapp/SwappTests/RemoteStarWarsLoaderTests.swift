//
//  RemoteStarWarsLoaderTests.swift
//  SwappTests
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation
import XCTest

class RemoteStarWarsLoader {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() {
        client.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteStarWarsLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteStarWarsLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClient()
        let sut = RemoteStarWarsLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}
