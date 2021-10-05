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

    init(model: People) {
        self.model = model
    }

    func view() -> UITableViewCell {
        let cell = PeopleCell()
        cell.name.text = model.name
        cell.language.text = model.species[0].language
        cell.vehicles.text = model.vehicles[0].name

        return cell
    }
}
