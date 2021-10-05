//
//  StarWarsImageDataLoader.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation

public protocol StarWarsImageDataLoaderTask {
    func cancel()
}

public protocol StarWarsImageDataLoader {
    func loadImageData(with queryParam: String) -> StarWarsImageDataLoaderTask
}
