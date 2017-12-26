//
//  FirstViewController.swift
//  WheresMyBrowser
//
//  Created by David Turco on 20/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import UIKit

class UIWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var urlBar: UITextField!
    @IBOutlet weak var uiWebView: UIWebView!
    @IBOutlet weak var progressBar: UIProgressView!

    @IBOutlet weak var scenarioButton: UIBarButtonItem!
    
    var progressBarTimer = Timer();
    var progressBarPageLoaded = false;
    var htmlData: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        uiWebView.delegate = self;

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
        uiWebView.loadRequest(URLRequest(url: url!));
        urlBar.resignFirstResponder();
    }
    
    func showOkAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func goToUrl(_ sender: Any) {
        loadUrlFromBar()
    }
    
    @IBAction func urlBarEditingGo(_ sender: UITextField) {
                loadUrlFromBar()
    }
    
    @IBAction func loadContentButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func selectScenarioButtonPressed(_ sender: UIBarButtonItem) {
        showScenarioSelection()
    }
    
    // Prepare for LoadContentViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoadContentViewController {
            let destination = segue.destination as! LoadContentViewController
            destination.parentWebView = self
        }
    }
    
    // Load data from LoadContentViewController into the Web View
    @IBAction func unwindToUIWebView(segue: UIStoryboardSegue) {
        let loadContentViewController = segue.source as! LoadContentViewController
        let htmlData = loadContentViewController.htmlData
        let htmlOrigin = loadContentViewController.htmlOrigin
        
        uiWebView.loadHTMLString(htmlData, baseURL: URL(string: htmlOrigin))
    }
    
    @IBOutlet weak var loadContentButtonPressed: UIBarButtonItem!
    func webViewDidStartLoad(_ webView: UIWebView) {
        // Fake progress bar
        progressBar.progress = 0;
        progressBarPageLoaded = false;
        progressBarTimer.invalidate();
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(UIWebViewController.progressBarTimerCallback), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        progressBarPageLoaded = true;
        urlBar.text = uiWebView.request?.url?.absoluteString;
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showOkAlert(title: "Resource failed to load", message: error.localizedDescription)
        progressBarPageLoaded = true;
        urlBar.text = uiWebView.request?.url?.absoluteString;
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let requestUrl = request.url;
        
        // Handle request with scheme javascriptbridge as internal function calls
        // For example to invoke the function getSecret from JavaScript use the URL:
        // javascriptbridge://getSecret/
        // the result will be retrned to the JavaScript page by calling the function
        // javascriptBridgeCallBack("getSecret", secret)
    
        if requestUrl != nil &&
            requestUrl!.scheme == "javascriptbridge" {
            print("Invoked javascriptbridge: " + requestUrl!.absoluteString)
            var javaScriptCallBack = ""
            switch requestUrl!.host {
            case "addNumbers"?:
                let arg1 = Double(requestUrl!.pathComponents[1])
                let arg2 = Double(requestUrl!.pathComponents[2])

                if arg1 != nil && arg2 != nil {
                    let result = arg1! + arg2!;
                    javaScriptCallBack = "javascriptBridgeCallBack('addNumbers','\(result)')"
                } else {
                    javaScriptCallBack = "javascriptBridgeCallBack('addNumbers','Error: invalid numbers')"
                }
                break
            case "getSecret"?:
                let secret = "EtWsaCCFS432"
                let javaScriptCallBack = "javascriptBridgeCallBack('getSecret','\(secret)')"
                uiWebView.stringByEvaluatingJavaScript(from: javaScriptCallBack)
                break
                
            default:
                return true
            }
            
            uiWebView.stringByEvaluatingJavaScript(from: javaScriptCallBack)
            // prevent webview from loading the URL
            return false
        }
        return true
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
    
    func showScenarioSelection() {
        
        let scenarioActionSheet = UIAlertController(title: "Select a scenario", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let scenario1Action = UIAlertAction(title: "Scenario 1", style: UIAlertActionStyle.default) { (action) in
            self.loadScenario1()
        }
        
        let scenario2Action = UIAlertAction(title: "Scenario 2", style: UIAlertActionStyle.default) { (action) in
            self.loadScenario2()
        }
        
        let scenario3Action = UIAlertAction(title: "Scenario 3", style: UIAlertActionStyle.default) { (action) in            self.loadScenario3()
        }
        
        let scenario4Action = UIAlertAction(title: "Scenario 4", style: UIAlertActionStyle.default) { (action) in            self.loadScenario4()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel scenario selection")
        })
        
        scenarioActionSheet.addAction(scenario1Action)
        scenarioActionSheet.addAction(scenario2Action)
        scenarioActionSheet.addAction(scenario3Action)
        scenarioActionSheet.addAction(scenario4Action)
        scenarioActionSheet.addAction(cancelAction)
        
        if let popoverController = scenarioActionSheet.popoverPresentationController {
            popoverController.barButtonItem = scenarioButton
        }
        
        self.present(scenarioActionSheet, animated: true, completion: nil)
    }
    
    func loadScenario1() {
        var scenario1Url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        scenario1Url = scenario1Url.appendingPathComponent("UIWebView/scenario1.html")
        uiWebView.loadRequest(URLRequest(url: scenario1Url))
    }
    
    func loadScenario2() {
        let scenario2HtmlPath = Bundle.main.url(forResource: "web/UIWebView/scenario2.html", withExtension: nil)
        do {
            let scenario2Html = try String(contentsOf: scenario2HtmlPath!, encoding: .utf8)
            uiWebView.loadHTMLString(scenario2Html, baseURL: nil)
        } catch {}
    }
    
    func loadScenario3() {
        let scenario3HtmlPath = Bundle.main.url(forResource: "web/UIWebView/scenario3.html", withExtension: nil)
        do {
            let scenario3Html = try String(contentsOf: scenario3HtmlPath!, encoding: .utf8)
            uiWebView.loadHTMLString(scenario3Html, baseURL: URL(string: "about:blank"))
        } catch {}
    }
    
    func loadScenario4() {
        let scenario4Url = Bundle.main.url(forResource: "web/UIWebView/scenario4.html", withExtension: nil)
        uiWebView.loadRequest(URLRequest(url: scenario4Url!))
    }
}

