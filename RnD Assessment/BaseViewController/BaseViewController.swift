//
//  BaseViewController.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView?

    @IBInspectable var screenTitle: String {
        get {
            return self.navigationItem.title ?? ""
        }
        set {
            self.navigationItem.title = newValue
        }
    }
    
    @IBInspectable var navigationBarRightButtonTitle: String? {
        didSet {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.navigationBarRightButtonTitle, style: .plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        }
    }
    
    @IBInspectable var navigationBarLeftButtonTitle: String? {
        didSet {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.navigationBarLeftButtonTitle, style: .plain, target: self, action: #selector(leftNavigationBarButtonTapped))
            self.navigationItem.leftBarButtonItem?.tintColor = .black
        }
    }
    
    @IBInspectable var navigationBarRightButtonImage: UIImage? {
        didSet {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: navigationBarRightButtonImage, style: .plain, target: self, action: #selector(rightNavigationBarButtonImageTapped))
        }
    }
    
    @IBInspectable var navigationBarLeftButtonImage: UIImage? {
        didSet {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.navigationBarLeftButtonImage, style: .plain, target: self, action: #selector(leftNavigationBarButtonImageTapped))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    func showErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func rightNavigationBarButtonTapped() {
        //override in child
    }
    
    @objc func leftNavigationBarButtonTapped() {
        //override in child
    }
    
    @objc func rightNavigationBarButtonImageTapped() {
        //override in child
    }
    
    @objc func leftNavigationBarButtonImageTapped() {
        //override in child
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
}
