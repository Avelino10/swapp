//
//  RemoteStarWarsLoaderTests.swift
//  SwappTests
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation
import Swapp
import XCTest

class RemoteStarWarsLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedError = [RemoteStarWarsLoader.Error]()

        sut.load { capturedError.append($0) }

        let clientError = NSError(domain: "an error", code: 0)
        client.complete(with: clientError)

        XCTAssertEqual(capturedError, [.connectivity])
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            var capturedError = [RemoteStarWarsLoader.Error]()
            sut.load { capturedError.append($0) }

            client.complete(withStatusCode: code, at: index)

            XCTAssertEqual(capturedError, [.invalidData])
        }
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteStarWarsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteStarWarsLoader(url: url, client: client)

        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!

            messages[index].completion(.success(response))
        }
    }
}
