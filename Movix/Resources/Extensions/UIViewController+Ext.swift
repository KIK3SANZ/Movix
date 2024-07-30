import UIKit

public var vSpinner: UIView?

public extension UIViewController{
    func showSpinner(onView: UIView = UIApplication.window){
        let spinnerView = UIView.init(frame: onView.bounds)
        DispatchQueue.main.async {
            spinnerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.66)
            let lotieContainer = UIView()
            let lottie = LottieManager(animationName: "loading")
            lottie.play(on: lotieContainer, loopAnimation: true, animationSpeed: 1.25)
            spinnerView.addAutolayoutSubview(lotieContainer, matchingAttributes: [.centerX, .centerY])
            lotieContainer.heightAnchor.constraint(equalTo: lotieContainer.widthAnchor, multiplier: 1.0).isActive = true
            lotieContainer.widthAnchor.constraint(equalTo: spinnerView.widthAnchor, multiplier: 200/375).isActive = true
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
        vSpinner?.tag = 101
    }
    
    func removeSpinner(){
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            //vSpinner = nil
        }
    }
    
    func showSpinner(_ isShowing: Bool){
        isShowing ? showSpinner() : removeSpinner()
    }
    
    func showAlert(withMessage message: String){
        let alert = UIAlertController.init(title: Bundle.appName(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "btn_ok".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(withMessage message: String, onAction handler: @escaping (UIAlertAction)->Void ){
        let alert = UIAlertController.init(title: Bundle.appName(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "btn_ok".localized, style: .cancel, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func showSheet(withMessage message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController.init(title: Bundle.appName(), message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "btn_cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
