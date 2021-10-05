//
//  PeopleCellController.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import UIKit

final class PeopleCellController {
    private let model: People
    private var cell: PeopleCell?

    init(model: People) {
        self.model = model
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        self.cell = tableView.dequeueReusableCell()
        cell?.name.text = model.name
        cell?.language.text = model.species[0].language
        cell?.vehicles.text = model.vehicles[0].name

        return cell!
    }
}
