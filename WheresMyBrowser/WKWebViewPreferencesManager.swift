//
//  WKWebViewPreferencesManager.swift
//  WheresMyBrowser
//
//  Created by David Turco on 26/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import Foundation
import WebKit

class WKWebViewPreferencesManager {
    
    let wkWebView:WKWebView
    let wkWebViewPreferences:WKPreferences
    let wkWebViewConfiguration:WKWebViewConfiguration
    
    init(wkWebView: WKWebView) {
        self.wkWebView = wkWebView
        self.wkWebViewConfiguration = wkWebView.configuration
        self.wkWebViewPreferences = wkWebView.configuration.preferences
    }
    
    func enableJavaScript(_ enabled: Bool) {
        wkWebViewPreferences.javaScriptEnabled = enabled
    }
    
    func enableJavaScriptBridge(_ enabled: Bool) {
        if enabled {
            let javaScriptBridgeMessageHandler = JavaScriptBridgeMessageHandler()
            let userContentController = wkWebViewConfiguration.userContentController
            userContentController.add(javaScriptBridgeMessageHandler, name: "javaScriptBridge")
        } else {
            let userContentController = wkWebViewConfiguration.userContentController
            userContentController.removeScriptMessageHandler(forName: "javaScriptBridge")
        }
    }
    
    func enableUndocumentedAllowAccessFromFileURLs(_ enabled: Bool) {
        // This is an undocumented workaround to allow file access from a file: origin
        if enabled {
            wkWebViewPreferences.setValue("Yes", forKey: "allowFileAccessFromFileURLs")
        } else {
            wkWebViewPreferences.setValue("No", forKey: "allowFileAccessFromFileURLs")
        }
    }
}
