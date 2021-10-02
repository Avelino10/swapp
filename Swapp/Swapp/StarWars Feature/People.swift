//
//  People.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public struct People: Equatable {
    public let name: String
    public let gender: String
    public let skinColor: String
    public var species: [Species]
    public var vehicles: [Vehicle]
    public var films: [Film]

    public init(name: String, gender: String, skinColor: String, species: [Species], vehicles: [Vehicle], films: [Film]) {
        self.name = name
        self.gender = gender
        self.skinColor = skinColor
        self.species = species
        self.vehicles = vehicles
        self.films = films
    }
}
