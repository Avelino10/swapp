//
//  StarWarsLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public enum LoadStarWarsResult {
    case success(People)
    case failure(Error)
}

public protocol StarWarsLoader {
    func load(completion: @escaping (LoadStarWarsResult) -> Void)
}
