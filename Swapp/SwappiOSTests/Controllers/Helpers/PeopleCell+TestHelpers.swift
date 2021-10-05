//
//  PeopleCell+TestHelpers.swift
//  SwappiOSTests
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Foundation
import SwappiOS

extension PeopleCell {
    var nameText: String? {
        name.text
    }

    var vehicleText: String? {
        vehicles.text
    }

    var renderedImage: Data? {
        languageImage.image?.pngData()
    }
}
