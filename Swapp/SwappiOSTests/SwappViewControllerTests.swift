//
//  SwappViewControllerTests.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation
import XCTest

final class SwappViewController {
    init(loader: SwappViewControllerTests.LoaderSpy) {
    }
}

final class SwappViewControllerTests: XCTestCase {
    func test_init_doesNotLoadList() {
        let loader = LoaderSpy()
        _ = SwappViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
