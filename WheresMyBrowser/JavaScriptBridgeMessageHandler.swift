//
//  JavascriptBridgeMessageHandler.swift
//  WheresMyBrowser
//
//  Created by David Turco on 26/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import Foundation
import WebKit

class JavaScriptBridgeMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageArray = message.body as! [String]
        let functionFromJS = messageArray[0]

        var result: String;
        switch functionFromJS {
            
            // The multiplyNumbers function can be called form JavaScript with:
            // window.webkit.messageHandlers.javaScriptBridge.postMessage(["multiplyNumbers", 3, 4]);
            // result will be passed by calling the JavaScript function javascriptBridgeCallBack(name, result)
            case "multiplyNumbers":
                
                let arg1 = Double(messageArray[1])!
                let arg2 = Double(messageArray[2])!
                result = String(arg1 * arg2)
            
            // The getSecret function can be called form JavaScript with:
            // window.webkit.messageHandlers.javaScriptBridge.postMessage(["getSecret"]);
            // result will be passed by calling the JavaScript function javascriptBridgeCallBack(name, result)
            case "getSecret":
                result = "XSRSOGKC342"
            
        default:
            result = "Error: unknown function"
        }
        
        let javaScriptCallBack = "javascriptBridgeCallBack('\(functionFromJS)','\(result)')"
        message.webView?.evaluateJavaScript(javaScriptCallBack, completionHandler: nil)
        print(message.body)
        
    }
}
