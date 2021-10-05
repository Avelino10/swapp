//
//  SwappViewController.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import UIKit

public final class SwappViewController: UITableViewController {
    private var loader: StarWarsLoader?
    private var tableModel = [People]()

    public convenience init(loader: StarWarsLoader) {
        self.init()
        self.loader = loader
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { [weak self] result in
            if let people = try? result.get() {
                self?.tableModel.append(people)
                self?.tableView.reloadData()
            }
        }
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = PeopleCell()
        cell.name.text = cellModel.name
        cell.language.text = cellModel.species[0].language
        cell.vehicles.text = cellModel.vehicles[0].name

        return cell
    }
}
