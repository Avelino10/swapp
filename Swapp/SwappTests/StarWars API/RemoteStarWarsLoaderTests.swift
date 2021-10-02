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

    func test_load_deliversSuccessOnClientErrorForSpeciesRequest() {
        let (sut, client) = makeSUT()

        let people = People(name: "people", gender: "male", skinColor: "black", species: [], vehicles: [], films: [])

        let peopleDict = [
            "name": people.name,
            "gender": people.gender,
            "skin_color": people.skinColor,
            "species":
                ["http://any-url.com",
                 "http://any-url.com"],
            "vehicles": people.vehicles,
            "films": people.films,
        ] as [String: Any]

        expect(sut, toCompleteWith: .success(people), when: {
            let peopleJson = try! JSONSerialization.data(withJSONObject: peopleDict)
            client.complete(withStatusCode: 200, data: peopleJson, at: 0)
            let clientError = NSError(domain: "an error", code: 0)
            client.complete(with: clientError, at: 1)
            client.complete(with: clientError, at: 2)
        })
    }

    func test_load_deliversSuccessWith1SpecieOnClientErrorForSecondSpeciesRequest() {
        let (sut, client) = makeSUT()

        let species = Species(name: "species", language: "portuguese")
        let people = People(name: "people", gender: "male", skinColor: "black", species: [species], vehicles: [], films: [])

        let peopleDict = [
            "name": people.name,
            "gender": people.gender,
            "skin_color": people.skinColor,
            "species":
                ["http://any-url.com",
                 "http://any-url.com"],
            "vehicles": people.vehicles,
            "films": people.films,
        ] as [String: Any]

        let speciesDict = [
            "name": species.name,
            "language": species.language,
        ] as [String: Any]

        expect(sut, toCompleteWith: .success(people), when: {
            let peopleJson = try! JSONSerialization.data(withJSONObject: peopleDict)
            client.complete(withStatusCode: 200, data: peopleJson, at: 0)
            let speciesJson = try! JSONSerialization.data(withJSONObject: speciesDict)
            client.complete(withStatusCode: 200, data: speciesJson, at: 1)
            let clientError = NSError(domain: "an error", code: 0)
            client.complete(with: clientError, at: 2)
        })
    }

    func test_load_deliversPeopleWithSpeciesOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()

        let species = Species(name: "species", language: "portuguese")
        let people = People(name: "people", gender: "male", skinColor: "black", species: [species], vehicles: [], films: [])

        let peopleDict = [
            "name": people.name,
            "gender": people.gender,
            "skin_color": people.skinColor,
            "species": ["http://any-species-url.com"],
            "vehicles": [],
            "films": [],
        ] as [String: Any]

        let speciesDict = [
            "name": species.name,
            "language": species.language,
        ] as [String: Any]



        expect(sut, toCompleteWith: .success(people), when: {
            let peopleJson = try! JSONSerialization.data(withJSONObject: peopleDict)
            let speciesJson = try! JSONSerialization.data(withJSONObject: speciesDict)
            client.complete(withStatusCode: 200, data: peopleJson, at: 0)
            client.complete(withStatusCode: 200, data: speciesJson, at: 1)
        })
    }

    func test_load_deliversPeopleWithVehiclesOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()

        let vehicle = Vehicle(name: "vehicles")
        let people = People(name: "people", gender: "male", skinColor: "black", species: [], vehicles: [vehicle], films: [])

        let peopleDict = [
            "name": people.name,
            "gender": people.gender,
            "skin_color": people.skinColor,
            "species": [],
            "vehicles": ["http://any-vehicle-url.com"],
            "films": [],
        ] as [String: Any]

        let vehicleDict = [
            "name": vehicle.name,
        ] as [String: Any]

        expect(sut, toCompleteWith: .success(people), when: {
            let peopleJson = try! JSONSerialization.data(withJSONObject: peopleDict)
            let vehicleJson = try! JSONSerialization.data(withJSONObject: vehicleDict)
            client.complete(withStatusCode: 200, data: peopleJson, at: 0)
            client.complete(withStatusCode: 200, data: vehicleJson, at: 1)
        })
    }

    func test_load_deliversPeopleWithFilmsOn200HTTPResponseWithValidJSON() {
        let (sut, client) = makeSUT()

        let film = Film(title: "film")
        let people = People(name: "people", gender: "male", skinColor: "black", species: [], vehicles: [], films: [film])

        let peopleDict = [
            "name": people.name,
            "gender": people.gender,
            "skin_color": people.skinColor,
            "species": [],
            "vehicles": [],
            "films": ["http://any-vehicle-url.com"],
        ] as [String: Any]

        let filmDict = [
            "title": film.title,
        ] as [String: Any]

        expect(sut, toCompleteWith: .success(people), when: {
            let peopleJson = try! JSONSerialization.data(withJSONObject: peopleDict)
            let filmJson = try! JSONSerialization.data(withJSONObject: filmDict)
            client.complete(withStatusCode: 200, data: peopleJson, at: 0)
            client.complete(withStatusCode: 200, data: filmJson, at: 1)
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
