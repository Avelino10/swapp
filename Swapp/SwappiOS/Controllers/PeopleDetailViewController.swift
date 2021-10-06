//
//  PeopleDetailViewController.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 06/10/2021.
//

import Swapp
import UIKit

class PeopleDetailViewController: UIViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var skinColor: UILabel!
    @IBOutlet var filmsList: UILabel!

    public var model: People?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }

    private func loadUI() {
        guard model != nil else {
            return
        }

        name.text = model?.name
        gender.text = model?.gender
        skinColor.text = model?.skinColor
        filmsList.text = model?.films.map { $0.title }.joined(separator: ", ")
    }
}
