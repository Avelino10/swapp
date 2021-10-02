//
//  RemoteStarWarsLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public class RemoteStarWarsLoader: StarWarsLoader {
    private let client: HTTPClient
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = StarWarsLoader.Result

    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success((data, response)):
                    if response.statusCode == 200, let peopleApi = try? JSONDecoder().decode(PeopleAPI.self, from: data) {
                        self?.getSpecies(peopleApi.species, people: peopleApi.people) { speciesResult in
                            if let people = try? speciesResult.get() {
                                self?.getVehicles(peopleApi.vehicles, people: people, completion: completion)
                            } else {
                                completion(.success(peopleApi.people))
                            }
                        }
                    } else {
                        completion(.failure(Error.invalidData))
                    }
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}

extension RemoteStarWarsLoader {
    private func getSpecies(_ url: [URL], people: People, completion: @escaping (Result) -> Void) {
        guard !url.isEmpty else {
            completion(.success(people))
            return
        }

        var people = people
        var species = [Species]()
        let dispatchGroup = DispatchGroup()
        for speciesUrl in url {
            dispatchGroup.enter()
            client.get(from: speciesUrl) { [weak self] result in
                guard self != nil else { return }
                switch result {
                    case let .success((data, response)):
                        if response.statusCode == 200, let speciesAPI = try? JSONDecoder().decode(SpeciesAPI.self, from: data) {
                            species.append(speciesAPI.species)
                        }
                    case .failure:
                        break
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            people.species = species
            completion(.success(people))
        }
    }
}

extension RemoteStarWarsLoader {
    private func getVehicles(_ url: [URL], people: People, completion: @escaping (Result) -> Void) {
        guard !url.isEmpty else {
            completion(.success(people))
            return
        }

        var people = people
        var vehicles = [Vehicle]()
        let dispatchGroup = DispatchGroup()
        for vehiclesUrl in url {
            dispatchGroup.enter()
            client.get(from: vehiclesUrl) { [weak self] result in
                guard self != nil else { return }
                switch result {
                    case let .success((data, response)):
                        if response.statusCode == 200, let vehiclesAPI = try? JSONDecoder().decode(VehiclesAPI.self, from: data) {
                            vehicles.append(vehiclesAPI.vehicle)
                        }
                    case .failure:
                        break
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            people.vehicles = vehicles
            completion(.success(people))
        }
    }
}

private struct PeopleAPI: Decodable {
    let name: String
    let gender: String
    let skin_color: String
    let species: [URL]
    let vehicles: [URL]
    let films: [URL]

    var people: People {
        People(name: name, gender: gender, skinColor: skin_color, species: [], vehicles: [], films: [])
    }
}

private struct SpeciesAPI: Decodable {
    let name: String
    let language: String

    var species: Species {
        Species(name: name, language: language)
    }
}

private struct VehiclesAPI: Decodable {
    let name: String

    var vehicle: Vehicle {
        Vehicle(name: name)
    }
}
