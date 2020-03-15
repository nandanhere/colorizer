//
//  sliderViewController.swift
//  colorizer
//
//  Created by Nandan on 21/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import AudioToolbox
var tt = false

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

func setupUI()
{

// label to indicate Hex value
hexValue.frame = CGRect(x: Int(self.view.frame.maxX /  2 ) - 75, y: 21, width: 135, height: 21)

// circular shaped button which will give user op
extractorButton.frame = CGRect(x: self.view.bounds.maxX / 2 -  35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 70, height: 70)
extractorButton.backgroundColor = .clear
extractorButton.layer.masksToBounds = true
extractorButton.layer.cornerRadius = 40
self.view.addSubview(extractorButton)
extractorButton.addTarget(self, action: #selector(sliderViewController.goToResultBuffe(_:)), for: .touchUpInside)
extractorButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(ViewController.goToTable(_:))))



//circular part of the extractor button
let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 70, height: 70))
extractorButtonShell.frame = CGRect(x: self.view.bounds.maxX / 2  - 35 , y: (self.view.bounds.maxY * 0.85) - 35, width: 50, height: 50)
extractorButtonShell.lineWidth = 3
extractorButtonShell.strokeColor = UIColor.label.cgColor
extractorButtonShell.path = linePath.cgPath
self.view.layer.insertSublayer(extractorButtonShell, at: 1)


}

override func viewDidLoad() {
super.viewDidLoad()
setupUI()

changeToColorType()
}
@objc func getReady() {
discoveredColor = tempColor
Display.text = discoveredColor?.name
Display.backgroundColor = discoveredColor
hexValue.text = discoveredColor?.hexString
halfAliveToSlider()

}


override func viewDidAppear(_ animated: Bool) {
getReady()
}


/// Function to execute when the user switches from halfAliveViewController To sliderViewController
func halfAliveToSlider(){ if  truth
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

// An unwind segue that comes back to this viewcontroller
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


/// Displays a Modal View of Buffer menu
/// - Parameter sender: Here the Circular button is the sender of the parameter
@objc func goToResultBuffe(_ sender : UIButton){
performSegue(withIdentifier: "slideToBuffer", sender: nil)
}
@objc func goToTable(_ sender:UILongPressGestureRecognizer){
performSegue(withIdentifier: "FromSlider", sender: nil)
AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
}

@IBAction func RedFunc(_ sender: Any) {
if tt { selfInputButton(self)}

ChangeColor()
ChangeLabelTxt()
discoveredColor = Display.backgroundColor
dataBaseColor = discoveredColor ?? UIColor.black
}
@IBAction func GreenFunc(_ sender: Any) {
if tt { selfInputButton(self)}

ChangeColor()
ChangeLabelTxt()
discoveredColor = Display.backgroundColor
dataBaseColor = discoveredColor ?? UIColor.black


}

@IBAction func BlueFunc(_ sender: Any) {
if tt { selfInputButton(self)}

ChangeColor()
ChangeLabelTxt()
discoveredColor = Display.backgroundColor
dataBaseColor = discoveredColor ?? UIColor.black


}

@IBAction func selfInputButton(_ sender: Any) {
ChangeColor()
guard Float(redType.text!) != nil else {Display.text = "Invalid Input" ; return}
guard Float(greenType.text!) != nil else {Display.text = "Invalid Input" ; return}
guard Float(blueType.text!) != nil else {Display.text = "Invalid Input" ; return}


if tt {
if truth {
redType.text = String(Float((discoveredColor?.components.red)!) * 255)
greenType.text = String(Float((discoveredColor?.components.green)!) * 255)
blueType.text = String(Float((discoveredColor?.components.blue)!) * 255)
}
else{
redType.text = String(Float((discoveredColor?.hsba.hue)!) * 360)
greenType.text = String(Float((discoveredColor?.hsba.saturation)!) * 100)
blueType.text = String(Float((discoveredColor?.hsba.brightness)!) * 100)
}
tt = false
}
if truth
{
RedSlider.setValue((Float(redType.text!)! / 255), animated: true)
GreenSlider.setValue((Float(greenType.text!)! / 255), animated: true)
BlueSlider.setValue((Float(blueType.text!)! / 255), animated: true)
ChangeColor()

}
else
{
RedSlider.setValue(((Float(redType.text!)! / 360)), animated: true)
GreenSlider.setValue((Float(greenType.text!)! / 100  ), animated: true)
BlueSlider.setValue((Float(blueType.text!)! / 100 ), animated: true)
ChangeColor()

}
changeToColorType()
ChangeLabelTxt()

}


@IBAction func goToPreviousView(_ sender: Any) {
if cameFromHalfAlive{
performSegue(withIdentifier: "unwindToHalfAliveFromSlider", sender: self )
}
else
{
performSegue(withIdentifier: "unwindToLiveFromSlider", sender: self )

}
}
let vc = LangViewController()

/// If the switch is on then it converts to the HSB values
//Changes the Color as well as Language depending on the bool value used in the LangViewController
func changeToColorType() {
var val :Bool = vc.defaultLang
if !truth{
if val == true{
RedLabel.text = "HueKey".localisableString(loc: "en")
GreenLabel.text = "SaturationKey".localisableString(loc: "en")
BlueLabel.text = "BrightnessKey".localisableString(loc: "en")
}
else{
RedLabel.text = "HueKey".localisableString(loc: "ja")
GreenLabel.text = "SaturationKey".localisableString(loc: "ja")
BlueLabel.text = "BrightnessKey".localisableString(loc: "ja")
}
RedSlider.tintColor = .systemTeal
GreenSlider.tintColor = .systemYellow
BlueSlider.tintColor = .systemIndigo
}
else
{
if val == true{
RedLabel.text = "RedKey".localisableString(loc: "en")
GreenLabel.text = "GreenKey".localisableString(loc: "en")
BlueLabel.text = "BlueKey".localisableString(loc: "en")
}
else{
RedLabel.text = "RedKey".localisableString(loc: "ja")
GreenLabel.text = "GreenKey".localisableString(loc: "ja")
BlueLabel.text = "BlueKey".localisableString(loc: "ja")
}
RedSlider.tintColor = .systemRed
GreenSlider.tintColor = .systemGreen
BlueSlider.tintColor = .systemBlue
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
extractorButtonShell.fillColor =  discoveredColor?.withAlphaComponent(0.75).cgColor

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
