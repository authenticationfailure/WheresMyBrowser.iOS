//
//  AppDelegate.swift
//  WheresMyBrowser
//
//  Created by David Turco on 20/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup of data
        
        /*
         This will store data in the user's default plist file located in the
         application's sandbox at:
         Library/Preferences/com.authenticationfailure.WheresMyBrowser.plist
        */
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "isFirstRun") {
            userDefaults.set(true, forKey: "isFirstRun")
            userDefaults.set("The secret is: IDXTT2Y3S", forKey: "Secret")
        }
        
        // Copy file for scenario1
        let scenario1HtmlOriginPath = Bundle.main.url(forResource: "web/UIWebView/scenario1.html", withExtension: nil)
        let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let scenario1DirDestinationPath = documentDirectoryPath.appendingPathComponent("UIWebView")
        let scenario1HtmlDestinationPath = documentDirectoryPath.appendingPathComponent("UIWebView/scenario1.html")
        do {
            try FileManager.default.createDirectory(at: scenario1DirDestinationPath, withIntermediateDirectories: false, attributes: nil)
            let scenario1Html = try String(contentsOf: scenario1HtmlOriginPath!, encoding: .utf8)
            try scenario1Html.write(to: scenario1HtmlDestinationPath, atomically: false, encoding: .utf8)
        } catch {
            NSLog("Error copying scenario files from bundle to document directory: \(error.localizedDescription)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

