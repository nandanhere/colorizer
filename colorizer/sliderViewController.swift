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
 @IBOutlet weak var redType: UITextField!
@IBOutlet weak var greenType: UITextField!
@IBOutlet weak var blueType: UITextField!
@IBOutlet weak var hexValue: UILabel!

let extractorButton = UIButton() // pressing the button will open a view which allows user to explore the color
let extractorButtonShell = CAShapeLayer() // Circular shape which is the "shell " for the buffer button
var RedColor : Float = 0
var BlueColor : Float = 0
var GreenColor : Float = 0

var Hue : Float = 0
var Saturation : Float = 0
var Brightness : Float = 0

var tempColor : UIColor!
@IBAction func unwindToSlider(segue: UIStoryboardSegue) {
    //nothing goes here
}

func addCircularButton()
{
// circular shaped button which will give user op
      extractorButton.frame = CGRect(x: self.view.bounds.maxX / 2 -  35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 70, height: 70)
      extractorButton.backgroundColor = .clear
      extractorButton.layer.masksToBounds = true
      extractorButton.layer.cornerRadius = 40
      self.view.addSubview(extractorButton)
            extractorButton.addTarget(self, action: #selector(sliderViewController.goToResultBuffe(_:)), for: .touchUpInside)


      

      //circular part of the extractor button
      let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 70, height: 70))
      extractorButtonShell.frame = CGRect(x: self.view.bounds.maxX / 2  - 35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 50, height: 50)
      extractorButtonShell.lineWidth = 3
      extractorButtonShell.strokeColor = UIColor.init(white: 2, alpha: 0.9).cgColor
      extractorButtonShell.path = linePath.cgPath
       self.view.layer.insertSublayer(extractorButtonShell, at: 1)
}

    override func viewDidLoad() {
        super.viewDidLoad()
       addCircularButton()
       
     changeToColorType()
     }



override func viewDidAppear(_ animated: Bool) {
discoveredColor = tempColor
Display.text = discoveredColor?.name
Display.backgroundColor = discoveredColor
hexValue.text = discoveredColor?.hexString
halfAliveToSlider()
}

func halfAliveToSlider()
{ if  truth
{
let color = discoveredColor?.components
 
RedColor = Float(((color?.red ?? 0.5) * 255).rounded())
GreenColor = Float(((color?.green ?? 0.5) * 255).rounded())
BlueColor = Float(((color?.blue ?? 0.5) * 255).rounded())
redType.text = "\(RedColor)"
greenType.text = "\(GreenColor)"
blueType.text = "\(BlueColor)"

}
else
{
Hue = Float(discoveredColor?.hsba.hue ?? 0.5)
Saturation = Float(Double(discoveredColor?.hsba.saturation ?? 0.5))
Brightness = Float(Double(discoveredColor?.hsba.brightness ?? 0.5))

redType.text = "\(Hue * 360)"
greenType.text = "\(Saturation * 100)"
blueType.text = "\(Brightness * 100)"

}
 
selfInputButton(self)

}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if let dataBufferPage = segue.destination as? dataBufferPage
{
dataBufferPage.tempColor = discoveredColor
}
else
{
return
}
}



@objc func goToResultBuffe(_ sender : UIButton)
{
performSegue(withIdentifier: "slideToBuffer", sender: nil)
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

@IBAction func selfInputButton(_ sender: Any) {
if truth
{RedSlider.setValue((Float(redType.text!)! / 255), animated: true)
GreenSlider.setValue((Float(greenType.text!)! / 255), animated: true)
BlueSlider.setValue((Float(blueType.text!)! / 255), animated: true)
}
else
{
RedSlider.setValue(((Float(redType.text!)! / 360)), animated: true)
GreenSlider.setValue((Float(greenType.text!)! / 100  ), animated: true)
BlueSlider.setValue((Float(blueType.text!)! / 100 ), animated: true)
}
ChangeColor()

}

/// If the switch is on then it converts to the HSB values
func changeToColorType() {
if !truth{
RedLabel.text = "Hue"
GreenLabel.text = "Saturation"
BlueLabel.text = "Brightness"
redType.text = "0.5"
greenType.text = "0.5"
blueType.text = "0.5"
RedSlider.tintColor = .systemTeal
GreenSlider.tintColor = .systemYellow
BlueSlider.tintColor = .white
}
}
func ChangeDisplayColor(){
   if truth
   {Display.backgroundColor = UIColor(red: CGFloat(RedColor), green: CGFloat(GreenColor), blue: CGFloat(BlueColor), alpha: 1.0)}
    else
   {
   Display.backgroundColor = UIColor(hue: CGFloat(Hue), saturation: CGFloat(Saturation), brightness: CGFloat(Brightness), alpha: 1)
}
Display.text = Display.backgroundColor?.name
}
func ChangeColor(){
   
if truth
  {   RedColor = RedSlider.value
    BlueColor = BlueSlider.value
    GreenColor = GreenSlider.value
  }
else
{
Hue = (Float(RedSlider.value))
Saturation = GreenSlider.value
Brightness = BlueSlider.value
}
    ChangeDisplayColor()
}
func ChangeLabelTxt(){
   let RedL = String(format: "%0.0f", (RedColor*255))
   let BlueL = String(format: "%0.0f", (GreenColor*255))
   let GreenL = String(format: "%0.0f", (BlueColor*255))
if truth {

    redType.text = "\(RedL)"
    greenType.text = "\(BlueL)"
    blueType.text = "\(GreenL)"
}
else
{
 
redType.text = "\((Hue * 360).rounded())"
greenType.text = "\(Saturation * 100)"
blueType.text = "\(Brightness * 100)"
}
hexValue.text = Display.backgroundColor?.hexString

 // This section changes the text color of the output so it is more readable
if (Int(RedL) == 255) && (Int(BlueL) == 0) && (Int(GreenL) == 255){
        Display.text = Display.backgroundColor?.name
    }

    else if (Int(RedL) == 255) && (Int(BlueL) == 255) && (Int(GreenL) == 255){
              Display.text = Display.backgroundColor?.name
          }

    else if (Int(RedL) == 0) && (Int(BlueL) == 0) && (Int(GreenL) == 0){
                     Display.text = Display.backgroundColor?.name
                 }
    else{
        Display.text = Display.backgroundColor?.name
    }
    if (Int(RedL)! < 55) || (Int(BlueL)! < 55) || (Int(GreenL)! < 55){
        Display.textColor = .white
    }
    else{
        Display.textColor = .black
    }
}
     

}
