/**
 *
 * Where's My Browser
 *
 * Copyright (C) 2017, 2018       David Turco
 *
 * This program can be distributed under the terms of the GNU GPL.
 * See the file COPYING.
 *
 * WARNING: This code is VULNERABLE-BY-DESIGN and it is intended as a learning tool
 *          DO NOT USE THIS CODE IN YOUR PROJECTS!!!
 *
 */

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var urlBar: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    
    var wkWebView: WKWebView!
    var wkWebViewPreferencesManager: WKWebViewPreferencesManager!
    
    var progressBarTimer = Timer();
    var progressBarPageLoaded = false;
    
    @IBOutlet weak var wkWebViewPlaceholder: UIView!
    
    @IBOutlet weak var scenarioButton: UIBarButtonItem!
    
    override func loadView() {
        super.loadView()
        
        let wkWebViewConfiguration: WKWebViewConfiguration!
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
        
        wkWebViewPreferencesManager = WKWebViewPreferencesManager(wkWebView: wkWebView);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showOkAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        backButton.isEnabled = wkWebView.canGoBack
        urlBar.text = wkWebView.url?.absoluteString;
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showOkAlert(title: "Resource failed to load", message: error.localizedDescription)
        progressBarPageLoaded = true;
        backButton.isEnabled = wkWebView.canGoBack
        urlBar.text = wkWebView.url?.absoluteString;
    }
    
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        showOkAlert(title: "Resource failed to load", message: error.localizedDescription)
        progressBarPageLoaded = true;
        backButton.isEnabled = wkWebView.canGoBack
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
    
    // Prepare for LoadContentViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoadContentViewController {
            let destination = segue.destination as! LoadContentViewController
            destination.parentWebView = self
        } else if segue.destination is WKPreferencesViewController {
            let destination = segue.destination as! WKPreferencesViewController
            destination.preferencesManager = self.wkWebViewPreferencesManager
        }
    }
    
    // Load data from LoadContentViewController into the Web View
    @IBAction func unwindToWKWebView(segue: UIStoryboardSegue) {
        let loadContentViewController = segue.source as! LoadContentViewController
        let htmlData = loadContentViewController.htmlData
        let htmlOrigin = loadContentViewController.htmlOrigin
        
        wkWebView.loadHTMLString(htmlData, baseURL: URL(string: htmlOrigin))
    }
    
    // Fake progress bar simulation
    @objc func progressBarTimerCallback() {
        if progressBarPageLoaded {
            progressBarTimer.invalidate();
            progressBar.progress = 0;
        } else {
            progressBar.progress = Float(wkWebView.estimatedProgress)
        }
    }
    
    func showScenarioSelection() {
        
        let scenarioActionSheet = UIAlertController(title: "Select a WKWebView scenario", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let scenario1Action = UIAlertAction(title: "Scenario 1", style: UIAlertActionStyle.default) { (action) in
            self.loadScenario1()
        }
        
        let scenario2Action = UIAlertAction(title: "Scenario 2", style: UIAlertActionStyle.default) { (action) in
            self.loadScenario2()
        }
        
        let scenario3Action = UIAlertAction(title: "Scenario 3", style: UIAlertActionStyle.default) { (action) in
            self.loadScenario3()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel scenario selection")
        })
        
        scenarioActionSheet.addAction(scenario1Action)
        scenarioActionSheet.addAction(scenario2Action)
        scenarioActionSheet.addAction(scenario3Action)
        scenarioActionSheet.addAction(cancelAction)
        
        if let popoverController = scenarioActionSheet.popoverPresentationController {
            popoverController.barButtonItem = scenarioButton
        }
        
        self.present(scenarioActionSheet, animated: true, completion: nil)
    }
    
    func loadScenario1() {
        self.wkWebViewPreferencesManager.enableJavaScript(true)
        self.wkWebViewPreferencesManager.enableJavaScriptBridge(false)
        self.wkWebViewPreferencesManager.enableUndocumentedAllowAccessFromFileURLs(false)
        
        var scenario1Url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        scenario1Url = scenario1Url.appendingPathComponent("WKWebView/scenario1.html")
        wkWebView.loadFileURL(scenario1Url, allowingReadAccessTo: scenario1Url)
    }
    
    func loadScenario2() {
        self.wkWebViewPreferencesManager.enableJavaScript(true)
        self.wkWebViewPreferencesManager.enableJavaScriptBridge(false)
        self.wkWebViewPreferencesManager.enableUndocumentedAllowAccessFromFileURLs(false)
        
        let scenario2HtmlPath = Bundle.main.url(forResource: "web/WKWebView/scenario2.html", withExtension: nil)
        do {
            let scenario2Html = try String(contentsOf: scenario2HtmlPath!, encoding: .utf8)
            wkWebView.loadHTMLString(scenario2Html, baseURL: nil)
        } catch {}
    }
    
    func loadScenario3() {
        self.wkWebViewPreferencesManager.enableJavaScript(true)
        self.wkWebViewPreferencesManager.enableJavaScriptBridge(true)
        self.wkWebViewPreferencesManager.enableUndocumentedAllowAccessFromFileURLs(false)
        
        let scenario4Url = Bundle.main.url(forResource: "web/WKWebView/scenario3.html", withExtension: nil)
        wkWebView.load(URLRequest(url: scenario4Url!))
    }

    @IBAction func goToUrl(_ sender: Any) {
        loadUrlFromBar()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }
    
    @IBAction func urlBarEditingGo(_ sender: UITextField) {
        loadUrlFromBar()
    }

    @IBAction func selectScenarioButtonPressed(_ sender: UIBarButtonItem) {
         showScenarioSelection()
    }
    
    @IBAction func loadContentButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}

