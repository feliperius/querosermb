//
//  UIStackView+RemoveAllArranged.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import UIKit

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        for view in removedSubviews {
            if view.superview != nil {
                NSLayoutConstraint.deactivate(view.constraints)
                view.removeFromSuperview()
            }
        }
    }
}
