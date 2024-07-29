import UIKit

extension UIView {
    @discardableResult
    func addAutolayoutSubview(_ view: UIView, matchingAttributes: [NSLayoutConstraint.Attribute]? = nil) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        if let matchingAttributes = matchingAttributes {
            let constraints = matchingAttributes.map {
                NSLayoutConstraint(item: view, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
            }
            addConstraints(constraints)
            return constraints
        } else {
            return []
        }
    }

    @discardableResult
    func addFillingSubview(_ view: UIView) -> [NSLayoutConstraint] {
        return addAutolayoutSubview(view, matchingAttributes: [.leading, .trailing, .top, .bottom])
    }
    
    func addBlurView(blurStyle: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
