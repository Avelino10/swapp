//
//  SwappViewController.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import UIKit

public final class SwappViewController: UITableViewController {
    var loader: StarWarsLoader?
    var imageDataLoader: StarWarsImageDataLoader?
    private var tableModel = [People]()
    private var cellControllers = [IndexPath: PeopleCellController]()

    override public func viewDidLoad() {
        super.viewDidLoad()

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