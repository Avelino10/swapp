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

        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "an error", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: Data(), at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalidJSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversPeopleOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()

        let people = People(name: "people", gender: "male", skinColor: "black", species: [], vehicles: [], films: [])

        let peopleJSON = [
            "name": people.name,
            "gender": people.gender,
            "skin_color": people.skinColor,
            "species": people.species,
            "vehicles": people.vehicles,
            "films": people.films,
        ] as [String: Any]

        expect(sut, toCompleteWith: .success(people), when: {
            let json = try! JSONSerialization.data(withJSONObject: peopleJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteStarWarsLoader? = RemoteStarWarsLoader(url: url, client: client)

        var capturedResults = [RemoteStarWarsLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        let invalidJSON = Data("invalidJSON".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteStarWarsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteStarWarsLoader(url: url, client: client)

        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)

        return (sut, client)
    }

    private func failure(_ error: RemoteStarWarsLoader.Error) -> RemoteStarWarsLoader.Result {
        .failure(error)
    }

    private func expect(_ sut: RemoteStarWarsLoader, toCompleteWith expectedResult: RemoteStarWarsLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedInfo), .success(expectedInfo)):
                    XCTAssertEqual(receivedInfo, expectedInfo, file: file, line: line)
                case let (.failure(receivedError as RemoteStarWarsLoader.Error), .failure(expectedError as RemoteStarWarsLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }
}
