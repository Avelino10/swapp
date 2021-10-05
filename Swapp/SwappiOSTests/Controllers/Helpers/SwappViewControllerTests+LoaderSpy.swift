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
    class LoaderSpy: StarWarsLoader {
        private var peopleCompletions = [(StarWarsLoader.Result) -> Void]()

        var loadCallCount: Int {
            peopleCompletions.count
        }

        func load(completion: @escaping (StarWarsLoader.Result) -> Void) {
            peopleCompletions.append(completion)
        }

        func completePeopleLoading(with people: People, at index: Int = 0) {
            peopleCompletions[index](.success(people))
        }
    }
}
