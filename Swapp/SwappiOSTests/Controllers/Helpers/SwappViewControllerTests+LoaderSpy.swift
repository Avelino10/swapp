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

        private(set) var loadedImageURLs = [URL]()
        private(set) var cancelledImageURLs = [URL]()

        func loadImageData(with queryParam: String) -> StarWarsImageDataLoaderTask {
            let url = URL(string: "https://eu.ui-avatars.com/api/?size=512&name=\(queryParam)")!
            loadedImageURLs.append(url)

            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
    }
}
