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
        cell = tableView.dequeueReusableCell()
        cell?.name.text = model.name
        cell?.language.text = model.species.isEmpty ? "no species" : model.species[0].language
        cell?.vehicles.text = model.vehicles.isEmpty ? "no vehicles" : getVehicleNames(from: model.vehicles)

        return cell!
    }

    private func getVehicleNames(from vehicles: [Vehicle]) -> String {
        var vehicleNames = ""

        for (index, vehicle) in vehicles.enumerated() {
            vehicleNames += vehicle.name
            if index < vehicles.count - 1 {
                vehicleNames += ", "
            }
        }

        return vehicleNames
    }
}
