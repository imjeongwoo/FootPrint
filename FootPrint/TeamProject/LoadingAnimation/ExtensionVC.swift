//
//  ExtensionVC.swift
//  TeamProject
//
//  Created by 임정우 on 2021/01/26.
//

import UIKit

class ExtensionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension UIViewController {
    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        
        spinnerView.backgroundColor = UIColor.init(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
