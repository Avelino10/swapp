//
//  SwappViewController+TestHelpers.swift
//  SwappiOSTests
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import SwappiOS
import UIKit

extension SwappViewController {
    func numberOfRenderedPeopleCells() -> Int {
        tableView.numberOfRows(inSection: peopleSection)
    }

    func peopleCell(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: peopleSection)

        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var peopleSection: Int {
        0
    }

    @discardableResult
    func simulatePeopleLanguageImageViewVisible(at index: Int) -> PeopleCell? {
        peopleCell(at: index) as? PeopleCell
    }

    func simulatePeopleLanguageImageViewNotVisible(at row: Int) {
        let view = simulatePeopleLanguageImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: peopleSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }

    func simulatePeopleImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: peopleSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulatePeopleImageViewNotNearVisible(at row: Int) {
        simulatePeopleImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: peopleSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
}
