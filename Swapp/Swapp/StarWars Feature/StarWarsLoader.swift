//
//  StarWarsLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public protocol StarWarsLoader {
    typealias Result = Swift.Result<[People], Error>

    func load(completion: @escaping (Result) -> Void)
}
