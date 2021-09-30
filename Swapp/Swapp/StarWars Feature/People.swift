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
    public let species: [URL]
    public let vehicles: [URL]
    public let films: [URL]

    public init(name: String, gender: String, skinColor: String, species: [URL], vehicles: [URL], films: [URL]) {
        self.name = name
        self.gender = gender
        self.skinColor = skinColor
        self.species = species
        self.vehicles = vehicles
        self.films = films
    }
}
