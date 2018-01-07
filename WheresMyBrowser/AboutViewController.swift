//
//  AboutViewController.swift
//  WheresMyBrowser
//
//  Created by David Turco on 31/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
    }
}
