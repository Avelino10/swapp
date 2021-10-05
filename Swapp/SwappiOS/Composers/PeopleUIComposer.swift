//
//  PeopleUIComposer.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import UIKit

public final class PeopleUIComposer {
    private init() {}

    public static func launchComposedWith(loader: StarWarsLoader) -> SwappViewController {
        let bundle = Bundle(for: SwappViewController.self)
        let storyboard = UIStoryboard(name: "People", bundle: bundle)
        let swappController = storyboard.instantiateInitialViewController() as! SwappViewController

        swappController.loader = loader

        return swappController
    }
}
