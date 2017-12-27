//
//  WKPreferencesViewController.swift
//  WheresMyBrowser
//
//  Created by David Turco on 27/12/2017.
//  Copyright © 2017 David Turco. All rights reserved.
//

import Foundation
import UIKit

protocol WKOptionsCellDelegate {
    func didChangeSwitchValue(_ option: String, enabled: Bool)
}

class WKOptionsViewCell: UITableViewCell {
    @IBOutlet weak var optionsSwitch: UISwitch!
    @IBOutlet weak var optionsNameLabel: UILabel!
    @IBOutlet weak var optionsDescriptionLabel: UILabel!
    
    var delegate: WKOptionsCellDelegate?
    var optionId: String?
    var optionName: String? {
        didSet {
            optionsNameLabel.text = optionName
        }
    }
    var optionDescription: String? {
        didSet {
            optionsDescriptionLabel.text = optionDescription
        }
    }
    
    var enabled: Bool = false {
        didSet {
            if enabled != optionsSwitch.isOn {
                optionsSwitch.setOn(enabled, animated: true)
            }
            delegate?.didChangeSwitchValue(optionId!, enabled: enabled)
        }
    }
    
    @IBAction func switchToggle(_ sender: Any) {
        enabled = (sender as! UISwitch).isOn
    }
}

class WKPreferencesViewController: UITableViewController, WKOptionsCellDelegate {
   
    var preferencesManager: WKWebViewPreferencesManager? = nil
    
    @IBOutlet var preferencesTableView: UITableView!
    
    override func viewDidLoad() {
        preferencesTableView.allowsSelection = false
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if preferencesManager != nil {
            return preferencesManager!.options.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionsCell = tableView.dequeueReusableCell(withIdentifier: "optionscell") as! WKOptionsViewCell
        let option = preferencesManager!.options[indexPath.item]
        optionsCell.optionId = option.id
        optionsCell.enabled = option.value
        optionsCell.optionName = option.name
        optionsCell.optionDescription = option.description
        optionsCell.delegate = self
        return optionsCell
    }
    
    func didChangeSwitchValue(_ option: String, enabled: Bool) {
        preferencesManager?.enableOption(option, enabled: enabled)
    }
}
