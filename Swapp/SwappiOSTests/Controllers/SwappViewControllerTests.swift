//
//  SwappViewControllerTests.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation
import Swapp
import SwappiOS
import XCTest

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

    func test_loadPeopleCompletion_rendersSuccessfullyLoadedItems() {
        let people = People(name: "people", gender: "male", skinColor: "blue", species: [Species(name: "species", language: "portuguese")], vehicles: [Vehicle(name: "vehicle")], films: [])
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completePeopleLoading(with: [people])
        assertThat(sut, isRendering: [people])
    }

    func test_peopleLanguageImageView_loadsImageURLWhenVisible() {
        let people = People(name: "people", gender: "male", skinColor: "blue", species: [Species(name: "species", language: "portuguese")], vehicles: [Vehicle(name: "vehicle")], films: [])
        let (sut, loader) = makeSUT()

        let url = URL(string: "https://eu.ui-avatars.com/api/?size=512&name=\(people.species[0].language)")!

        sut.loadViewIfNeeded()
        loader.completePeopleLoading(with: [people])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulatePeopleLanguageImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [url], "Expected first image URL requests once first view becomes visible")
    }

    func test_peopleLanguageImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let people = People(name: "people", gender: "male", skinColor: "blue", species: [Species(name: "species", language: "portuguese")], vehicles: [Vehicle(name: "vehicle")], films: [])
        let (sut, loader) = makeSUT()

        let url = URL(string: "https://eu.ui-avatars.com/api/?size=512&name=\(people.species[0].language)")!

        sut.loadViewIfNeeded()
        loader.completePeopleLoading(with: [people])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")

        sut.simulatePeopleLanguageImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [url], "Expected on cancelled image URL request once first image is not visible anymore")
    }

    func test_peopleLanguageImageView_rendersImageLoadedFromURL() {
        let people = People(name: "people", gender: "male", skinColor: "blue", species: [Species(name: "species", language: "portuguese")], vehicles: [Vehicle(name: "vehicle")], films: [])
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completePeopleLoading(with: [people])

        let view0 = sut.simulatePeopleLanguageImageViewVisible(at: 0)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")

        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: SwappViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PeopleUIComposer.launchComposedWith(loader: loader, imageDataLoader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
    }

    private func assertThat(_ sut: SwappViewController, isRendering people: [People], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedPeopleCells() == people.count else {
            return XCTFail("Expected \(people.count) people, got \(sut.numberOfRenderedPeopleCells()) instead.", file: file, line: line)
        }

        people.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    private func assertThat(_ sut: SwappViewController, hasViewConfiguredFor people: People, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.peopleCell(at: index)

        guard let cell = view as? PeopleCell else {
            return XCTFail("Expected \(PeopleCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.nameText, people.name, "Expected name text to be \(String(describing: people.name)) for people view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.vehicleText, people.vehicles[0].name, "Expected vehicle text to be \(String(describing: people.vehicles[0].name)) for people view at index (\(index))", file: file, line: line)
    }
}
