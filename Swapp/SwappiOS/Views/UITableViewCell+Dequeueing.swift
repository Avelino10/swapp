//
//  UITableViewCell+Dequeueing.swift
//  SwappiOS
//
//  Created by Avelino Rodrigues on 05/10/2021.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
