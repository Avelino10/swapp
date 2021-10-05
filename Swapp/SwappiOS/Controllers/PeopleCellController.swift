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
    private let imageLoader: StarWarsImageDataLoader
    private var task: StarWarsImageDataLoaderTask?

    init(model: People, imageDataLoader: StarWarsImageDataLoader) {
        self.model = model
        imageLoader = imageDataLoader
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.name.text = model.name

        if !model.species.isEmpty {
            cell?.language.text = model.species[0].language

            task = imageLoader.loadImageData(with: model.species[0].language)
        } else {
            cell?.language.text = "no species"
        }

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

    deinit {
        task?.cancel()
    }
}
