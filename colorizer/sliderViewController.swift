//
//  sliderViewController.swift
//  colorizer
//
//  Created by Nandan on 21/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit

class sliderViewController: UIViewController {

@IBOutlet weak var RedLabel: UILabel!
@IBOutlet weak var RedSlider: UISlider!
@IBOutlet weak var GreenLabel: UILabel!
@IBOutlet weak var GreenSlider: UISlider!
@IBOutlet weak var BlueLabel: UILabel!
@IBOutlet weak var BlueSlider: UISlider!
@IBOutlet weak var Display: UILabel!


var RedColor : Float = 0
var BlueColor : Float = 0
var GreenColor : Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
@IBAction func RedFunc(_ sender: Any) {
ChangeColor()
ChangeLabelTxt()
}
@IBAction func GreenFunc(_ sender: Any) {
ChangeColor()
ChangeLabelTxt()
}

@IBAction func BlueFunc(_ sender: Any) {
ChangeColor()
ChangeLabelTxt()
}

func ChangeDisplayColor(){
    Display.backgroundColor = UIColor(red: CGFloat(RedColor), green: CGFloat(GreenColor), blue: CGFloat(BlueColor), alpha: 1.0)
}
func ChangeColor(){
    RedColor = RedSlider.value
    BlueColor = BlueSlider.value
    GreenColor = GreenSlider.value
    ChangeDisplayColor()
}
func ChangeLabelTxt(){
    let RedL = String(format: "%0.0f", (RedColor*255))
    let BlueL = String(format: "%0.0f", (BlueColor*255))
    let GreenL = String(format: "%0.0f", (GreenColor*255))
    RedLabel.text = "Red : \(RedL)"
    BlueLabel.text = "Blue : \(BlueL)"
    GreenLabel.text = "Green : \(GreenL)"
    if (Int(RedL) == 255) && (Int(BlueL) == 0) && (Int(GreenL) == 255){
        Display.text = "Yellow"
    }
    
    else if (Int(RedL) == 255) && (Int(BlueL) == 255) && (Int(GreenL) == 255){
              Display.text = "White"
          }

    else if (Int(RedL) == 0) && (Int(BlueL) == 0) && (Int(GreenL) == 0){
                     Display.text = "Black"
                 }
    else{
        Display.text = "Colour"
    }
    if (Int(RedL)! < 55) || (Int(BlueL)! < 55) || (Int(GreenL)! < 55){
        Display.textColor = .white
    }
    else{
        Display.textColor = .black
    }
}
     

}
