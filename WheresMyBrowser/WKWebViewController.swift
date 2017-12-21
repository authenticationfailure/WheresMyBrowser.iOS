//
//  SecondViewController.swift
//  WheresMyBrowser
//
//  Created by David Turco on 20/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var urlBar: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var wkWebView: WKWebView!
    var wkWebViewConfiguration: WKWebViewConfiguration!
    var progressBarTimer = Timer();
    var progressBarPageLoaded = false;
    
    @IBOutlet weak var wkWebViewPlaceholder: UIView!
    
    
    override func loadView() {
        super.loadView()
        wkWebViewConfiguration = WKWebViewConfiguration()
        
        // WKWebViews placed using the interface builder return an error if
        // the deployment target is < iOS 11.
        // https://stackoverflow.com/questions/46221577/xcode-9-gm-wkwebview-nscoding-support-was-broken-in-previous-versions
        // Need to implement the WKWebView programmatically
        
        let webViewFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.wkWebViewPlaceholder.frame.size.height))
        wkWebView = WKWebView(frame: webViewFrame, configuration: wkWebViewConfiguration)
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebViewPlaceholder.addSubview(wkWebView)

        wkWebView.topAnchor.constraint(equalTo: wkWebViewPlaceholder.topAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: wkWebViewPlaceholder.bottomAnchor).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: wkWebViewPlaceholder.leadingAnchor).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: wkWebViewPlaceholder.trailingAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Fake progress bar
        progressBar.progress = 0;
        progressBarPageLoaded = false;
        progressBarTimer.invalidate();
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(WKWebViewController.progressBarTimerCallback), userInfo: nil, repeats: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBarPageLoaded = true;
        urlBar.text = wkWebView.url?.absoluteString;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUrlFromBar() {
        var url = URL(string: urlBar.text!);
        if url == nil {
            url = URL(string:"about:blank");
        }
        wkWebView.load(URLRequest(url: url!));
        urlBar.resignFirstResponder();
    }
    
    // Fake progress bar simulation
    @objc func progressBarTimerCallback() {
        if progressBarPageLoaded {
            if progressBar.progress >= 1 {
                progressBarTimer.invalidate();
                progressBar.progress = 0;
            } else {
                progressBar.progress += 0.1;
            }
        } else {
            progressBar.progress += 0.05;
            if progressBar.progress >= 0.95 {
                progressBar.progress = 0.95;
            }
        }
    }

    @IBAction func goToUrl(_ sender: Any) {
        loadUrlFromBar()
    }

    @IBAction func urlBarEditingGo(_ sender: UITextField) {
        loadUrlFromBar()
    }
}

