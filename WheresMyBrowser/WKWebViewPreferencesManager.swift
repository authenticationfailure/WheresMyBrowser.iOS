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

import Foundation
import WebKit

class WKWebViewPreferencesManager {
    
    let wkWebView:WKWebView
    let wkWebViewPreferences:WKPreferences
    let wkWebViewConfiguration:WKWebViewConfiguration
    
    public class WebViewSetting {
        let id: String
        let name: String
        let description: String
        var value: Bool = false
        
        init(id:String, name:String, description:String, value:Bool) {
            self.id = id
            self.name = name
            self.description = description
            self.value = value
        }
    }
    
    public private(set) var options = [
        WebViewSetting(id: "javaScript",
               name: "JavaScript",
               description: "Enables support for JavaScript within the WebView",
               value: true),
        
        WebViewSetting(id: "javaScriptBridge",
               name: "JavaScript Bridge",
               description: "Enables the JavaScript to native bridge message handler with name 'javaScriptBridge'",
               value: true),
        
        WebViewSetting(id: "undocumentedAllowAccessFromFileURL",
               name: "Allow File Access from File",
               description: "Allows file:// resources to access other files. This uses the undocumented 'allowFileAccessFromFileURLs' of 'WebViewPreferences'",
               value: false)
    ]
    
    var option_ids : [String] = []
    var options_dict: [String:WebViewSetting] = [:]
    
    init(wkWebView: WKWebView) {
        self.wkWebView = wkWebView
        self.wkWebViewConfiguration = wkWebView.configuration
        self.wkWebViewPreferences = wkWebView.configuration.preferences
        
        for option in options {
            option_ids.append(option.id)
            options_dict[option.id] = option
        }
    }
    
    func enableOption(_ id: String, enabled: Bool ) {
        if option_ids.contains(id) {
            switch id {
            case "javaScript":
                enableJavaScript(enabled)
            case "javaScriptBridge":
                enableJavaScriptBridge(enabled)
            case "undocumentedAllowAccessFromFileURL":
                enableUndocumentedAllowAccessFromFileURLs(enabled)
            default:break
            }
        }
    }
    
    func isOptionEnabled(_ id: String) -> Bool {
        if option_ids.contains(id) {
            return options_dict[id]!.value
        }
        return false
    }
    
    func enableJavaScript(_ enabled: Bool) {
        options_dict["javaScript"]?.value = enabled
        if wkWebViewPreferences.javaScriptEnabled != wkWebViewPreferences.javaScriptEnabled {
            wkWebViewPreferences.javaScriptEnabled = enabled
            wkWebView.reload()
        }
    }
    
    func enableJavaScriptBridge(_ enabled: Bool) {
        options_dict["javaScriptBridge"]?.value = enabled
        let userContentController = wkWebViewConfiguration.userContentController
        userContentController.removeScriptMessageHandler(forName: "javaScriptBridge")
        
        if enabled {
            let javaScriptBridgeMessageHandler = JavaScriptBridgeMessageHandler()
            userContentController.add(javaScriptBridgeMessageHandler, name: "javaScriptBridge")
        }
    }
    
    func enableUndocumentedAllowAccessFromFileURLs(_ enabled: Bool) {
        options_dict["undocumentedAllowAccessFromFileURL"]?.value = enabled
        // This is an undocumented workaround to allow file access from a file: origin
        if enabled {
            wkWebViewPreferences.setValue("Yes", forKey: "allowFileAccessFromFileURLs")
        } else {
            wkWebViewPreferences.setValue("No", forKey: "allowFileAccessFromFileURLs")
        }
    }
}
