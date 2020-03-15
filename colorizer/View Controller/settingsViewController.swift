//
//  settingsViewController.swift
//  colorizer
//
//  Created by Nandan on 09/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import OnboardKit
import MessageUI
import Firebase
import SQLite
extension String{
//String Extension necessary to change languages
func localisableString(loc:String)->String{
let path = Bundle.main.path(forResource: loc, ofType: "lproj")
let bundle = Bundle(path: path!)
return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}
}
extension UIView {
//Label Blink function
  func blink() {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.isRemovedOnCompletion = false
    animation.fromValue           = 1
    animation.toValue             = 0
    animation.duration            = 0.8
    animation.autoreverses        = true
    animation.repeatCount         = 5
    animation.beginTime           = CACurrentMediaTime() + 0.5
    self.layer.add(animation, forKey: nil)
    }
}
var LoggedIn = false
class settingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

@IBOutlet weak var ContactButt: UIButton!
@IBOutlet weak var Logout: UIButton!
@IBOutlet weak var Teller: UILabel!

@IBOutlet weak var hsb: UISwitch!
@IBOutlet weak var rgb: UISwitch!
@IBOutlet weak var EmailLab: UILabel!
@IBOutlet weak var deleteAllButton: UIButton!
@IBOutlet weak var Shower: UILabel!
@IBOutlet weak var Shower2: UILabel!
@IBOutlet weak var Language: UIButton!

@IBOutlet weak var InstVid: UIButton!
@IBOutlet weak var Helper: UIButton!
@IBOutlet weak var RGBDataLab: UILabel!

@IBOutlet weak var RGBTitle: UILabel!
@IBOutlet weak var EmailButt: UIButton!
@IBAction func unwindToSetting(segue:UIStoryboardSegue) { }

@IBOutlet weak var DelDescp: UILabel!
@IBOutlet weak var DelLab: UILabel!

@IBOutlet weak var HSBdescp: UILabel!

@IBOutlet weak var HSBDataLab: UILabel!

var database : Connection!
let usersTable = Table("users")
var editTextfield : String = ""
let name = Expression<String?>("name")
let hexCode = Expression<String>("hexCode")
//OnboardScreen for First time User declaration
lazy var onboardingPages: [OnboardPage] = {
  let pageOne = OnboardPage(title: "Welcome to Colorizer ", imageName: "Drop", description: "Colorizer is an easy to use color detecting app designed to help artists discover various colors.\n All you need is your phone with you, and you are all set for the adventures destined.")

let pageTwo = OnboardPage(title: "The Color Picker",imageName: "HalfAlive",
    description: "Use the photo gallery or the camera to import the image.\n Use the CrossHair to choose a colour.\n The RGB Values and Hexcode are shown on the top.\n Press the lower circular button to display various colors.Long press it to display your saved data.")

  let pageThree = OnboardPage(title: "Saving your Findings", imageName: "Buffer" , description: "The background color of output label gives the dominant color.\n There are 5 buttons each having different colors and hexcode,but related to the original color.\n Click on a button you like, to save it to our database.")
 let table = OnboardPage(title: "Your Saved Data", imageName: "Table" , description: "All your saved data will be stored here and you edit or delete them by swiping right or left respectively.You can search them by the search bar provided above.Click on the color present in your entry to change the selected color to your color.")

let pageFour = OnboardPage(title: "The Bar Buttons", imageName: "Bar", description: "Press the Share button on the top right corner to share your findings with your friends.\n Press the cart button to be redirected to our trusted supplier of watercolor's site where you can buy your discovered color as a watercolor.\nClick the Events button to know the events happening near you."
                             )
 let purchase = OnboardPage(title: "Purchasing A Product", imageName: "Amazon" , description: "Once you enter into our Client's site,you can purchase your color in form of watercolors that can aid in your day to day arts.")

let pageFive = OnboardPage(title: "Live Color Picker", imageName: "Drop5", description: "Have you gone out and found a beautiful color and have been intrigued about it?\n We have the right feature for you.\n Just click on the live video camera button and start discovering various colors anywhere you go."
)
let pageSix = OnboardPage(title: "Color Slider", imageName: "Slider", description: "Know the RBG/HSB values and want to discover the color?\n Colorizer is here for you.\n Just press the slider button in any view and input your value and click the manual button.\n Bored? Play around with the slider and make new colors."
)
let pageSeven = OnboardPage(title: "Settings Screen", imageName: "Settings", description: "Change the RGB to HSB here anytime. \n Login to our site.\n If you ever are stuck somewhere,you can use help or contact us anytime for queries."
)
 let logger = OnboardPage(title: "Logging In", imageName: "Login" , description: "Login/SignUp into our database and get added benefits in our app.\nSignUp consists of entering your email address and a 8 charactered password.\nYou can always skip signing up.")
 let lang = OnboardPage(title: "Selecting Your Language", imageName: "Language" , description: "Select the language your comfortable in to apply it all over our app as to aid in simplifying your work.")
  let pageEight = OnboardPage(title: "All Ready",
    description: "You are all set and ready to discover new colors. Let's Begin!",
    advanceButtonTitle: "Begin")

  return [pageOne, pageTwo, pageThree,table, pageFour, purchase, pageFive,pageSix, pageSeven,logger,lang, pageEight]
}()
var def = UserDefaults().bool(forKey: "pickerViewRow")
//MARK: - Override
override func viewDidLoad() {
let vc = LangViewController()
var val : Bool = vc.defaultLang
        super.viewDidLoad()
//Language Changer
langchange()
//Checks if this is the first time if app is launched
if let isFirstStart = UserDefaults.standard.value(forKey: "isFirstLaunch") as? Bool {
Shower2.isHidden = true
Shower.isHidden = true
}
else {
Shower2.isHidden = true
Shower.blink()
}
deleteAllButton.layer.masksToBounds = true
deleteAllButton.layer.cornerRadius = 15
if defaults == true{

hsb.isOn = false
rgb.isOn = true
truth = true
}
else if defaults2 == true{
hsb.isOn = true
rgb.isOn = false
truth = false
}
if LoggedIn == true{
Logout.setTitle("    LogOut", for: .normal)
EmailLab.text = Auth.auth().currentUser?.email ?? "-"
}
else{
Logout.setTitle("    LogIn", for: .normal)
}
    

do{
let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
let database = try Connection(fileUrl.path)
self.database = database
print("database created")
}
catch
{
print("error creating the datbase")
}

    }
override func viewWillAppear(_ animated: Bool) {
//Language Changer
langchange()
let vc = LangViewController()
var val : Bool = vc.defaultLang
if val == true{
Teller.text = "English"
}
else{
Teller.text = "日本語(Japanese)"
}
}
//Language Changer
func langchange(){
let vc = LangViewController()
var val : Bool = vc.defaultLang
//English
if val == true{
//Language Displayer
self.languageShower(selectedlang: "en")
}
//Japanese
else{
//Language Displayer
self.languageShower(selectedlang: "ja")
}
}

//Language Displayer
func languageShower(selectedlang:String){
Helper.setTitle("HelpKey".localisableString(loc: selectedlang), for: .normal)
Language.setTitle("LangKey".localisableString(loc: selectedlang), for: .normal)
EmailButt.setTitle("EmailKey".localisableString(loc: selectedlang), for: .normal)
RGBDataLab.text = "RgbDataKey".localisableString(loc: selectedlang)
if LoggedIn == false{
Logout.setTitle("LoginKey".localisableString(loc: selectedlang), for: .normal)
}
else{
Logout.setTitle("LogoutKey".localisableString(loc: selectedlang), for: .normal)
}
DelLab.text = "DelLabKey".localisableString(loc: selectedlang)
DelDescp.text = "RevKey".localisableString(loc: selectedlang)
deleteAllButton.setTitle("DelButKey".localisableString(loc: selectedlang), for: .normal)
ContactButt.setTitle("ContKey".localisableString(loc: selectedlang), for: .normal)
RGBTitle.text="RGBTKey".localisableString(loc: selectedlang)
HSBDataLab.text = "HSBTKey".localisableString(loc: selectedlang)
HSBdescp.text = "HSBDataKey".localisableString(loc: selectedlang)
InstVid.setTitle("InstKey".localisableString(loc: selectedlang), for: .normal)
}

var defaults = UserDefaults().bool(forKey: "SwitchStateRGB")
var defaults2 = UserDefaults().bool(forKey: "SwitchStateHSB")
// The two functions below allow the user to change the overall RGB datatype to HSB and back, according to user preference
//MARK: - Color UISwitch
@IBAction func rgbf(_ sender: Any) {
if rgb.isOn {
truth = true
hsb.setOn(false, animated: true)
UserDefaults().set(true, forKey: "SwitchStateRGB")
UserDefaults().set(false, forKey: "SwitchStateHSB")
}
else
{
truth = false
hsb.setOn(true, animated: true)
UserDefaults().set(true, forKey: "SwitchStateHSB")
UserDefaults().set(false, forKey: "SwitchStateRGB")
}
tt = true

}

@IBAction func hsb(_ sender: Any) {
if hsb.isOn {
truth = false
rgb.setOn(false, animated: true)
UserDefaults().set(true, forKey: "SwitchStateHSB")
UserDefaults().set(false, forKey: "SwitchStateRGB")
}
else{
truth = true
rgb.setOn(true, animated: true)
UserDefaults().set(true, forKey: "SwitchStateRGB")
UserDefaults().set(false, forKey: "SwitchStateHSB")
}
tt = true

}
//OnboardScreen Displayer
@IBAction func Walker(_ sender: Any) {
Shower.isHidden = true
//Checks if its first run or not
if let isFirstStart = UserDefaults.standard.value(forKey: "isFirstLaunch") as? Bool {
print("Not First Launch")
}
else {
Shower.isHidden = true
print("Its a first")
self.Shower2.isHidden = false
DispatchQueue.main.asyncAfter(deadline: .now() + 20){
self.Shower2.blink()
}
UserDefaults.standard.set(false, forKey: "isFirstLaunch")
UserDefaults.standard.synchronize()
}
let titlecolor:UIColor = .white

let boldTitleFont = UIFont(name: "AppleSDGothicNeo-Bold" , size: 32) ?? UIFont.systemFont(ofSize: 32.0, weight: .semibold)
let mediumTextFont = UIFont(name: "AppleSDGothicNeo-Light" , size: 17) ?? UIFont.systemFont(ofSize: 17.0, weight: .semibold)
//Onboard Screen UI code
let ApConfig = OnboardViewController.AppearanceConfiguration(titleColor: .white, textColor: titlecolor, backgroundColor: .black, titleFont: boldTitleFont, textFont: mediumTextFont)
let onboardingVC = OnboardViewController(pageItems: onboardingPages, appearanceConfiguration: ApConfig,completion: {print("Success")})
onboardingVC.modalPresentationStyle = .formSheet
onboardingVC.presentFrom(self, animated: true)
}


@IBAction func deleteAllSavedColors(_ sender: Any) {
 let vc = LangViewController()
var val : Bool = vc.defaultLang
var dec = ""
if val == true{
dec = "en"
}
else{
dec = "ja"
}
let alert = UIAlertController(title: "DelA".localisableString(loc: dec), message: "RevKey".localisableString(loc: dec), preferredStyle: UIAlertController.Style.alert)
let deleteAction = UIAlertAction(title: "Delete".localisableString(loc: dec), style: .destructive) { (alertAction) in

let cdeleteUser = self.usersTable.drop(ifExists: true)
do
{
try self.database.run(cdeleteUser)
print("sucessfully deleted all ")
}
catch
{

print("error deleting")
}
}
let cancelAction = UIAlertAction(title: "Cancel".localisableString(loc: dec), style: .cancel) { (alertAction) in
  print("cancel button tapped")}

alert.addAction(cancelAction)
alert.addAction(deleteAction)
 present(alert , animated: true , completion: nil)
}
//Sends an email to our email adress
@IBAction func Mailer(_ sender: Any) {
let recipientEmail = "team@Colorize.com"
    let subject = "Your issue or praise:"
    let body = "The details of the subject :)"

    // Show default mail composer
    if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([recipientEmail])
        mail.setSubject(subject)
        mail.setMessageBody(body, isHTML: false)

        present(mail, animated: true)

    // Show third party email composer if default Mail app is not present
    } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
        UIApplication.shared.open(emailUrl)
    }
}
//Uses the mail app and incorporates various email sites
private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
        return gmailUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
        return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
        return yahooMail
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
        return sparkUrl
    }

    return defaultUrl
}
//Dismissal Function
func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
}
//Button used to either Login or Logout
@IBAction func Logouter(_ sender: Any) {
UserDefaults.standard.set(false, forKey: "isFirstLaunch")
UserDefaults.standard.synchronize()
//LogOut
if LoggedIn == true{
let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
let yes = UIAlertAction(title: "Yes", style: .default, handler: { _ in
do
{
//Signs Out the current User
try Auth.auth().signOut();LoggedIn = false;fromSetting = true

}
catch let someerror{
print(someerror)
}
self.performSegue(withIdentifier: "LogoutDone", sender: self)
})
let No = UIAlertAction(title: "No", style: .default)

alert.addAction(No)
alert.addAction(yes)
self.present(alert,animated: true,completion: nil)

}
else{
fromSetting = true
self.performSegue(withIdentifier: "LogoutDone", sender: self)

}
}
@IBAction func Fronter(_ sender: Any) {
performSegue(withIdentifier: "SetToLang", sender: self)
}

}

     


