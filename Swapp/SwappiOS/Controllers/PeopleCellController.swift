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
            let language = model.species[0].language
            let url = URL(string: "https://eu.ui-avatars.com/api/?size=512&name=\(language.getAcronyms())")!
            task = imageLoader.loadImageData(from: url) { [weak cell] result in
                let data = try? result.get()

                if let image = data.map(UIImage.init) {
                    if Thread.isMainThread {
                        cell?.languageImage.image = image
                    } else {
                        DispatchQueue.main.async {
                            cell?.languageImage.image = image
                        }
                    }
                }
            }
        } else {
            cell?.languageImage.image = nil
        }

        cell?.vehicles.text = model.vehicles.isEmpty ? "no vehicles" : getVehicleNames(from: model.vehicles)

        return cell!
    }

    public func preload() {
        if !model.species.isEmpty {
            let language = model.species[0].language
            let url = URL(string: "https://eu.ui-avatars.com/api/?size=512&name=\(language.getAcronyms())")!
            task = imageLoader.loadImageData(from: url) { _ in }
        }
    }

    public func cancelLoad() {
        task?.cancel()
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
        cell = nil
        task?.cancel()
    }
}

extension String {
    public func getAcronyms(separator: String = "") -> String {
        var acronyms = components(separatedBy: " ").filter { !$0.isEmpty }.map({ String($0.first!) }).joined(separator: separator)

        if acronyms.count == 1 {
            acronyms = "\(prefix(1))\(suffix(1))"
        }

        return acronyms
    }
}
