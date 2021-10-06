//
//  SwappViewControllerTests+LoaderSpy.swift
//  SwappiOSTests
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation
import Swapp
import SwappiOS

extension SwappViewControllerTests {
    class LoaderSpy: StarWarsLoader, StarWarsImageDataLoader {
        // MARK: - StarWarsLoader

        private var peopleCompletions = [(StarWarsLoader.Result) -> Void]()

        var loadCallCount: Int {
            peopleCompletions.count
        }

        func load(completion: @escaping (StarWarsLoader.Result) -> Void) {
            peopleCompletions.append(completion)
        }

        func loadNext(completion: @escaping (StarWarsLoader.Result) -> Void) {
            peopleCompletions.append(completion)
        }

        func completePeopleLoading(with people: [People] = [], at index: Int = 0) {
            peopleCompletions[index](.success(people))
        }

        // MARK: - StarWarsImageDataLoader

        private struct TaskSpy: StarWarsImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }

        private var imageRequests = [(url: URL, completion: (StarWarsImageDataLoader.Result) -> Void)]()

        var loadedImageURLs: [URL] {
            imageRequests.map { $0.url }
        }

        private(set) var cancelledImageURLs = [URL]()

        func loadImageData(from url: URL, completion: @escaping (StarWarsImageDataLoader.Result) -> Void) -> StarWarsImageDataLoaderTask {
            imageRequests.append((url, completion))

            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }

        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
    }
}
