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
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> StarWarsImageDataLoaderTask
}
