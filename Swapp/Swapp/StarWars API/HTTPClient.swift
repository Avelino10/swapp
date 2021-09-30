//
//  HTTPClient.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 30/09/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
