//
//  SwappViewControllerTests.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation
import Swapp
import XCTest

final class SwappViewController: UIViewController {
    private var loader: StarWarsLoader?

    convenience init(loader: StarWarsLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in }
    }
}

final class SwappViewControllerTests: XCTestCase {
    func test_init_doesNotLoadList() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_viewDidLoad_loadsList() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SwappViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = SwappViewController(loader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
    }

    class LoaderSpy: StarWarsLoader {
        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (StarWarsLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
