//
//  LoadContentViewController.swift
//  WheresMyBrowser
//
//  Created by David Turco on 24/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import Foundation
import UIKit

class LoadContentViewController: UIViewController {
    @IBOutlet weak var baseUrlTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    // use this to distinguish which webview
    var parentWebView: UIViewController!
    var htmlData = "<h1>Hello World</h1>"
    var htmlOrigin = ""

    
    @IBAction func doneButtonPressed(_ sender: Any) {
        htmlData = contentTextView.text
        htmlOrigin = baseUrlTextField.text!
        if parentWebView is UIWebViewController {
            self.performSegue(withIdentifier: "unwindToUiWebView", sender: self)
        }
        if parentWebView is WKWebViewController {
            self.performSegue(withIdentifier: "unwindToWKWebView", sender: self)
        }
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let webViewController = subsequentVC as! UIWebViewController
        webViewController.htmlData = "Hello"
        print("Unwind")
        
    }
    
    
}
