import UIKit

public extension UIApplication {
    static var window: UIWindow {
        guard let appDelegate = UIApplication.shared.delegate?.window else {
            fatalError("Window could not be instantiated")
        }
        return appDelegate!
    }
}
