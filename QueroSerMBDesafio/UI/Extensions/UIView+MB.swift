import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}

extension UIView {
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }

    func applyNavBarConstraints(size: (width: CGFloat, height: CGFloat)) {
        let widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }

    func roundCorners(_ corners: UIRectCorner, cornerMask: CACornerMask, radius: CGFloat) {
        DispatchQueue.main.async {
            if #available(iOS 11.0, *) {
                self.clipsToBounds = false
                self.layer.cornerRadius = radius
                self.layer.maskedCorners = cornerMask
            } else {
                let rectShape = CAShapeLayer()
                rectShape.bounds = self.frame
                rectShape.position = self.center
                rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
                self.layer.mask = rectShape
            }
        }
    }

    func roundCorners(_ corners: UIRectCorner, radius: Int, fillColor: UIColor = .white) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillColor = fillColor.cgColor
        layer.mask = maskLayer
        clipsToBounds = true
        path.close()
    }

    func fadeIn(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.1, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.3
        }, completion: completion)
    }

    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }

    convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
    }
    
    func addSubview<T: UIView>(_ view: T, constraints: [NSLayoutConstraint]) {
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraints)
    }
}
