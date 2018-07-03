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
import UIKit

class MainTabBarViewController: UITabBarController {
    var checkedForUpdates = false
    let updatesURL = "https://www.authenticationfailure.com/wmb/releases/iOS.latest"
    
    struct UpdateData: Codable {
        let latest_version: String
        let download_url: String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForUpdates()
    }
    
    func checkForUpdates() {
        if !checkedForUpdates {
            checkedForUpdates = true
            
            let defaultSession = URLSession(configuration: .default)
            defaultSession.configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            let dataTask: URLSessionDataTask?
            let url = URL(string: updatesURL)
            
            dataTask = defaultSession.dataTask(with: url!) {data, response, error in
                if data != nil, (response as? HTTPURLResponse)?.statusCode == 200 {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let updateData = try jsonDecoder.decode(UpdateData.self, from: data!)
                        let current_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                        let ver_cmp = updateData.latest_version.compare(current_version, options: .numeric)
                        if ver_cmp == .orderedDescending  {
                            let message = "A newer version of the application is available. Download it from \(updateData.download_url)"
                            let title = "Update Available"
                            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        return
                    }
                    catch {}
                }
                NSLog("Check for updates failed.")
            }
            
            dataTask?.resume()

        }
    }
}
