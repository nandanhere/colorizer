//
//  dataBufferPage.swift
//  colorizer
//
//  Created by Nandan on 25/01/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import Firebase
var dataBaseColor : UIColor = .black
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
@IBOutlet weak var Shopper: UIButton!
@IBAction func unwindTobuffer(segue:UIStoryboardSegue) { }


func setupUI()
{
 discoveredColor = dataBaseColor
//Complementary
let c1 : UIColor = UIColor(red:( 1 -  (discoveredColor?.coreImageColor.red ?? 0.5)), green: (1 - (discoveredColor?.coreImageColor.green ?? 0.5) ), blue: (1 - (discoveredColor?.coreImageColor.blue ?? 0.5)), alpha: 1)

b1.clipsToBounds = true
b1.layer.cornerRadius = 35
b1.backgroundColor = c1
b1.setTitle(c1.name, for: .normal)
b1.setTitleColor(c1.isDarkColor == true ? .white : .black, for: .normal)
l1.text = c1.hexString


//Real Color
b2.clipsToBounds = true
b2.layer.cornerRadius = 35
b2.backgroundColor = discoveredColor
b2.setTitle(discoveredColor?.name, for: .normal)
b2.setTitleColor(discoveredColor?.isDarkColor == true ? .white : .black, for: .normal)
l2.text = discoveredColor?.hexString


//Monochrome
let c3 : UIColor = UIColor(red: 0.299 * (discoveredColor?.coreImageColor.red ?? 0.5) , green:   0.587 * (discoveredColor?.coreImageColor.green ?? 0.5)  , blue: (0.114 * (discoveredColor?.coreImageColor.blue ?? 0.5)), alpha: 1)
b3.clipsToBounds = true
b3.layer.cornerRadius = 35
b3.backgroundColor = c3
b3.setTitle(c3.name, for: .normal)
b3.setTitleColor(c3.isDarkColor == true ? .white : .black, for: .normal)
l3.text = c3.hexString


//Lighter
let c4 : UIColor = discoveredColor?.lighter() ?? .white
b4.clipsToBounds = true
b4.layer.cornerRadius = 35
b4.backgroundColor = c4
b4.setTitle(c4.name, for: .normal)
b4.setTitleColor(c4.isDarkColor == true ? .white : .black, for: .normal)
l4.text = c4.hexString

//something
let c5 : UIColor = UIColor(red: 0.5 * (discoveredColor?.coreImageColor.red ?? 0.5) , green:   ( (discoveredColor?.coreImageColor.green ?? 0.5) / 2 )  , blue: 0.5 * (discoveredColor?.coreImageColor.blue ?? 0.5), alpha: 1)
b5.clipsToBounds = true
b5.layer.cornerRadius = 35
b5.backgroundColor = c5
b5.setTitle(c5.name, for: .normal)
b5.setTitleColor(c5.isDarkColor == true ? .white : .black, for: .normal)
l5.text = c5.hexString


//darker
let c6 : UIColor = discoveredColor?.darker() ?? .black
b6.clipsToBounds = true
b6.layer.cornerRadius = 35
if ((discoveredColor?.coreImageColor.red ?? 0.5) <= CGFloat(0.3) || (discoveredColor?.coreImageColor.green ?? 0.5) <= 0.3 || (discoveredColor?.coreImageColor.blue ?? 0.5) <= 0.3) {
b6.backgroundColor = .black
b6.setTitle("Black", for: .normal)
b6.setTitleColor(c6.isDarkColor == true ? .white : .black, for: .normal)
l6.text = "#000000"
}
else{
b6.backgroundColor = c6
b6.setTitle(c6.name, for: .normal)
b6.setTitleColor(c6.isDarkColor == true ? .white : .black, for: .normal)
l6.text = c6.hexString
}
}

// functions dealing with each button in the buffer view
@IBAction func butt1(_ sender: Any) {
dataBaseColor = self.b1.backgroundColor ?? UIColor.black
performSegue(withIdentifier: "goToDataBaseFromBuffer", sender: self)
}

@IBAction func butt2(_ sender: Any) {
dataBaseColor = self.b2.backgroundColor ?? UIColor.black
performSegue(withIdentifier: "goToDataBaseFromBuffer", sender: self)
}
@IBAction func butt3(_ sender: Any) {
dataBaseColor = self.b3.backgroundColor ?? UIColor.black
performSegue(withIdentifier: "goToDataBaseFromBuffer", sender: self)

}
@IBAction func butt4(_ sender: Any) {
dataBaseColor = self.b4.backgroundColor ?? UIColor.black
performSegue(withIdentifier: "goToDataBaseFromBuffer", sender: self)
}
@IBAction func butt5(_ sender: Any) {
dataBaseColor = self.b5.backgroundColor ?? UIColor.black
performSegue(withIdentifier: "goToDataBaseFromBuffer", sender: self)
}
@IBAction func butt6(_ sender: Any) {
dataBaseColor = self.b6.backgroundColor ?? UIColor.black
performSegue(withIdentifier: "goToDataBaseFromBuffer", sender: self)
}


override func viewDidLoad() {
super.viewDidLoad()
discoveredColor = tempColor
outputlabel.text = "Selected Color - \(dataBaseColor.name) \n Domiant color - \(dominantColor.name)"
outputlabel.backgroundColor = dominantColor
if dominantColor.isDarkColor == true{
outputlabel.textColor = .white
}
else{
outputlabel.textColor = .black
}
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

@IBAction func Sharer(_ sender: Any) {
let SharingVC = UIActivityViewController(activityItems: ["I discovered this brand new color called \((discoveredColor?.name)!) with its hexcode as \((discoveredColor?.hexString)!).You can do that too! Just search 'colorizer' in the app store and discover the artist in you!"], applicationActivities: nil)
if let pop = SharingVC.popoverPresentationController{
pop.sourceView = self.view
pop.sourceRect = (sender as AnyObject).frame

}
self.present(SharingVC, animated: true, completion: nil)
}
@IBAction func Purchaser(_ sender: Any) {
dataBaseColor = discoveredColor ?? UIColor.black
if Auth.auth().currentUser != nil{
performSegue(withIdentifier: "GoGoHikashi", sender: self)
}
else{
let alert = UIAlertController(title: "Not Logged In", message: "Login to access more features", preferredStyle: .alert)
let login = UIAlertAction(title: "LogIn", style: .default, handler: { _ in
fromWeb = true
self.performSegue(withIdentifier: "LogWeb", sender: self)
})
let NotNow = UIAlertAction(title: "Not Now", style: .default, handler: { _ in
self.performSegue(withIdentifier: "GoGoHikashi", sender: self)
})

alert.addAction(NotNow)
alert.addAction(login)
self.present(alert, animated: true, completion: nil)
}
}





}
