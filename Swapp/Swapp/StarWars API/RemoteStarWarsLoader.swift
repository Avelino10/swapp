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

    public typealias Result = LoadStarWarsResult

    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success(data, response):
                    if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                        completion(.success(root.people))
                    } else {
                        completion(.failure(Error.invalidData))
                    }
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let name: String
    let gender: String
    let skin_color: String
    let species: [URL]
    let vehicles: [URL]
    let films: [URL]

    var people: People {
        People(name: name, gender: gender, skinColor: skin_color, species: species, vehicles: vehicles, films: films)
    }
}
