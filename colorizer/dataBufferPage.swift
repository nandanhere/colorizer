//
//  dataBufferPage.swift
//  colorizer
//
//  Created by Nandan on 25/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit

class dataBufferPage: UIViewController {

var tempColor : UIColor!
@IBOutlet weak var outputlabel: UILabel!
@IBOutlet weak var b1: UIButton!
@IBOutlet weak var b2: UIButton!
@IBOutlet weak var b3: UIButton!
@IBOutlet weak var b4: UIButton!
@IBOutlet weak var b5: UIButton!
@IBOutlet weak var b6: UIButton!
@IBOutlet weak var l1: UILabel!
@IBOutlet weak var l2: UILabel!
@IBOutlet weak var l3: UILabel!
@IBOutlet weak var l4: UILabel!
@IBOutlet weak var l5: UILabel!
@IBOutlet weak var l6: UILabel!

func setupUI()
{
//Complementary
let c1 : UIColor = UIColor(red:( 1 -  (discoveredColor?.coreImageColor.red ?? 0.5)), green: (1 - (discoveredColor?.coreImageColor.green ?? 0.5) ), blue: (1 - (discoveredColor?.coreImageColor.blue ?? 0.5)), alpha: 1)
 
b1.clipsToBounds = true
b1.layer.cornerRadius = 50
b1.backgroundColor = c1
b1.setTitle(c1.name, for: .normal)
b1.setTitleColor(c1.isDarkColor == true ? .white : .black, for: .normal)
l1.text = c1.hexString


//Real Color
b2.clipsToBounds = true
b2.layer.cornerRadius = 50
b2.backgroundColor = discoveredColor
b2.setTitle(discoveredColor?.name, for: .normal)
b2.setTitleColor(discoveredColor?.isDarkColor == true ? .white : .black, for: .normal)
l2.text = discoveredColor?.hexString


//Monochrome
let c3 : UIColor = UIColor(red: 0.299 * (discoveredColor?.coreImageColor.red ?? 0.5) , green:   0.587 * (discoveredColor?.coreImageColor.green ?? 0.5)  , blue: (0.114 * (discoveredColor?.coreImageColor.blue ?? 0.5)), alpha: 1)
b3.clipsToBounds = true
b3.layer.cornerRadius = 50
b3.backgroundColor = c3
b3.setTitle(c3.name, for: .normal)
b3.setTitleColor(c3.isDarkColor == true ? .white : .black, for: .normal)
l3.text = c3.hexString


//Lighter
let c4 : UIColor = discoveredColor?.lighter() ?? .white
b4.clipsToBounds = true
b4.layer.cornerRadius = 50
b4.backgroundColor = c4
b4.setTitle(c4.name, for: .normal)
b4.setTitleColor(c4.isDarkColor == true ? .white : .black, for: .normal)
l4.text = c4.hexString

//something
let c5 : UIColor = UIColor(red: 0.5 * (discoveredColor?.coreImageColor.red ?? 0.5) , green:   ( (discoveredColor?.coreImageColor.green ?? 0.5) / 2 )  , blue: 0.5 * (discoveredColor?.coreImageColor.blue ?? 0.5), alpha: 1)
b5.clipsToBounds = true
b5.layer.cornerRadius = 50
b5.backgroundColor = c5
b5.setTitle(c5.name, for: .normal)
 b5.setTitleColor(c5.isDarkColor == true ? .white : .black, for: .normal)
l5.text = c5.hexString


//darker
let c6 : UIColor = discoveredColor?.darker() ?? .black
b6.clipsToBounds = true
b6.layer.cornerRadius = 50
b6.backgroundColor = c6
b6.setTitle(c6.name, for: .normal)
b6.setTitleColor(c6.isDarkColor == true ? .white : .black, for: .normal)
l6.text = c6.hexString
}

    override func viewDidLoad() {
        super.viewDidLoad()
        discoveredColor = tempColor
    outputlabel.text = "OUTPUT"
    setupUI()
    
       
        // Do any additional setup after loading the view.
    }
override func viewDidAppear(_ animated: Bool) {
setupUI()
}
@IBAction func returnToPreviousView(_ sender: Any) {
self.dismiss(animated: true) {
 
}
}


     

}
