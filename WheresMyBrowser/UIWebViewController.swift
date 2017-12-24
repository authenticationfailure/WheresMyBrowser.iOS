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
            print("Scenario 1 selected")
            self.loadScenario1()
        }
        
        let scenario2Action = UIAlertAction(title: "Scenario 2", style: UIAlertActionStyle.default) { (action) in
            print("Scenario 2 selected")
        }
        
        let scenario3Action = UIAlertAction(title: "Scenario 3", style: UIAlertActionStyle.default) { (action) in
            print("Scenario 3 selected")
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
        var scenario1Url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        scenario1Url = scenario1Url.appendingPathComponent("scenario1.html")
        uiWebView.loadRequest(URLRequest(url: scenario1Url))
    }
}

