//
//  Extension.swift
//  AssignmentSnapWork
//
//  Created by SMN Boy on 02/02/22.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius(_ radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
}



extension UITableView {
    
    func registerWithNib(nib: UITableViewCell.Type) {
        let identifier = String(describing: nib)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
}
