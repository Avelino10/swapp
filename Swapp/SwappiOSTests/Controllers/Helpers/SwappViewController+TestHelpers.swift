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

    func simulatePeopleLanguageImageViewVisible(at index: Int) {
        _ = peopleCell(at: index)
    }
}
