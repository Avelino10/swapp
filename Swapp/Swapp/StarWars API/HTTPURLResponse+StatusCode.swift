//
//  HTTPURLResponse+StatusCode.swift
//  Swapp
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
