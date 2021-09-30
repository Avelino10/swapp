//
//  StarWarsLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

enum LoadStarWarsResult {
    case success(People)
    case error(Error)
}

protocol StarWarsLoader {
    func load(completion: @escaping (LoadStarWarsResult) -> Void)
}
