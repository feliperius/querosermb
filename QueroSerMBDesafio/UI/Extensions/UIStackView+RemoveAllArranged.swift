//
//  UIStackView+RemoveAllArranged.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

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
    func addBackgroundGradiant(_ color1: UIColor, color2: UIColor, cornerRadius: CGFloat = 10) {
          let backgroundView = UIView(frame: bounds)
          backgroundView.backgroundColor = .clear
          backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

          let gradientLayer = CAGradientLayer()
          gradientLayer.frame = backgroundView.bounds
          gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.blue.cgColor]
          backgroundView.layer.insertSublayer(gradientLayer, at: 0)

          backgroundView.layer.cornerRadius = cornerRadius

          insertSubview(backgroundView, at: 0)
      }
}
