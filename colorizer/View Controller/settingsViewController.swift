//
//  settingsViewController.swift
//  colorizer
//
//  Created by Nandan on 09/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit

class settingsViewController: UITableViewController {

@IBOutlet weak var hsb: UISwitch!
@IBOutlet weak var rgb: UISwitch!
override func viewDidLoad() {
        super.viewDidLoad()
hsb.isOn = !truth
rgb.isOn = truth

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

@IBAction func rgbf(_ sender: Any) {
if rgb.isOn {
truth = true
hsb.setOn(false, animated: true)}
else
{
truth = false
hsb.setOn(true, animated: true)
}
}

@IBAction func hsb(_ sender: Any) {
if hsb.isOn {
truth = false
rgb.setOn(false, animated: true)
}
else{
truth = true
rgb.setOn(true, animated: true)
}
}

 

 
     

}
