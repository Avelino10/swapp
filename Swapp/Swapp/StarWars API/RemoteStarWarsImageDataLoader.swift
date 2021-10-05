//
//  RemoteStarWarsImageDataLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation

public class RemoteStarWarsImageDataLoader: StarWarsImageDataLoader {
    private let client: HTTPClient
    public init(client: HTTPClient) {
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private final class HTTPClientTaskWrapper: StarWarsImageDataLoaderTask {
        private var completion: ((StarWarsImageDataLoader.Result) -> Void)?

        var wrapper: HTTPClientTask?

        init(_ completion: @escaping (StarWarsImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: StarWarsImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapper?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (StarWarsImageDataLoader.Result) -> Void) -> StarWarsImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapper = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { data, response in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }

        return task
    }
}
