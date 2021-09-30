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

        expect(sut, toCompleteWithError: .invalidData, when: {
            let invalidJSON = Data("invalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData, when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithError: .invalidData, when: {
            let invalidJSON = Data("invalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteStarWarsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteStarWarsLoader(url: url, client: client)

        return (sut, client)
    }

    private func expect(_ sut: RemoteStarWarsLoader, toCompleteWithError error: RemoteStarWarsLoader.Error, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedErrors = [RemoteStarWarsLoader.Error]()
        sut.load { capturedErrors.append($0) }

        action()

        XCTAssertEqual(capturedErrors, [error], file: file, line: line)
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

        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!

            messages[index].completion(.success(data, response))
        }
    }
}
