//
//  SwappViewController.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import UIKit

public final class SwappViewController: UITableViewController, UITableViewDataSourcePrefetching {
    var loader: StarWarsLoader?
    var imageDataLoader: StarWarsImageDataLoader?
    private var tableModel = [People]()
    private var cellControllers = [IndexPath: PeopleCellController]()

    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.prefetchDataSource = self

        loader?.load { [weak self] result in
            if let people = try? result.get() {
                self?.tableModel = people
                if Thread.isMainThread {
                    self?.tableView.reloadData()
                } else {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view(in: tableView)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = tableModel[indexPath.row]

            let language = cellModel.species[0].language
            let url = URL(string: "https://eu.ui-avatars.com/api/?size=512&name=\(language.getAcronyms())")!
            _ = imageDataLoader?.loadImageData(from: url) { _ in }
        }
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }

    private func cellController(forRowAt indexPath: IndexPath) -> PeopleCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = PeopleCellController(model: cellModel, imageDataLoader: imageDataLoader!)
        cellControllers[indexPath] = cellController

        return cellController
    }
}
