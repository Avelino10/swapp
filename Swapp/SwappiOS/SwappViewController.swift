//
//  SwappViewController.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import Swapp
import UIKit

public final class SwappViewController: UIViewController {
    private var loader: StarWarsLoader?

    public convenience init(loader: StarWarsLoader) {
        self.init()
        self.loader = loader
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in }
    }
}
