//
//  RemoteStarWarsLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public class RemoteStarWarsLoader {
    private let client: HTTPClient
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable {
        case success(People)
        case failure(Error)
    }

    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
                case let .success(data, response):
                    if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                        completion(.success(root.people))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure:
                    completion(.failure(.connectivity))
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
