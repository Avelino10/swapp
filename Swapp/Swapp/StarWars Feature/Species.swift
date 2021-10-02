//
//  Species.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public struct Species: Equatable {
    public let name: String
    public let language: String

    public init(name: String, language: String) {
        self.name = name
        self.language = language
    }
}
