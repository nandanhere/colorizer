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
class settingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

@IBOutlet weak var hsb: UISwitch!
@IBOutlet weak var rgb: UISwitch!
lazy var onboardingPages: [OnboardPage] = {
  let pageOne = OnboardPage(title: "Welcome to Colorizer ", imageName: "Drop", description: "Colorizer is an easy to use color detecting app designed to help artists discover various colors.\n All you need is your phone with you, and you are all set for the adventures destined.")

let pageTwo = OnboardPage(title: "The Color Picker",imageName: "Drop2",
    description: "Use the photo gallery or the camera to import the image.\n Use the CrossHair and go to the part at which you need your color to be discovered.\n The RGB Values and Hexcode are shown on the top.\n Press the lower circular button to display various colors.")

  let pageThree = OnboardPage(title: "Saving your Findings", imageName: "Drop3" , description: "The background color of output label gives the dominant color.\n There are 5 buttons each having different colors and hexcode,but related to the original color.\n Click on a button you like, to save it to our database.")

let pageFour = OnboardPage(title: "Sharing and Purchasing", imageName: "Drop4", description: "Press the Share button on the top right corner to share your findings with your friends.\n Press the cart button to be redirected to our trusted supplier of watercolor's site where you can buy your discovered color as a watercolor."
                             )
let pageFive = OnboardPage(title: "Live Color Picker", imageName: "Drop5", description: "Have you gone out and found a beautiful color and have been intrigued about it?\n We have the right feature for you.\n Just click on the live video camera button and start discovering various colors anywhere you go."
)
let pageSix = OnboardPage(title: "Color Slider", imageName: "Drop6", description: "Know the RBG/HSB values and want to discover the color?\n Colorizer is here for you.\n Just press the slider button in any view and input your value and click the manual button.\n Bored? Play around with the slider and make new colors."
)
let pageSeven = OnboardPage(title: "Settings Screen", imageName: "Drop7", description: "Change the RGB to HSB here anytime. \n Access your saved data.\n If you ever are stuck somewhere,you can use help or contact us anytime for queries."
)

  let pageEight = OnboardPage(title: "All Ready",
    description: "You are all set and ready to discover new colors. Let's Begin!",
    advanceButtonTitle: "Begin")

  return [pageOne, pageTwo, pageThree, pageFour, pageFive,pageSix, pageSeven, pageEight]
}()
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

@IBAction func Walker(_ sender: Any) {
let titlecolor:UIColor = .white

let boldTitleFont = UIFont.systemFont(ofSize: 32.0, weight: .bold)
let mediumTextFont = UIFont.systemFont(ofSize: 17.0, weight: .semibold)

let ApConfig = OnboardViewController.AppearanceConfiguration(titleColor: .white, textColor: titlecolor, backgroundColor: .black, titleFont: boldTitleFont, textFont: mediumTextFont)
let onboardingVC = OnboardViewController(pageItems: onboardingPages, appearanceConfiguration: ApConfig,completion: {print("Success")})
onboardingVC.modalPresentationStyle = .formSheet
onboardingVC.presentFrom(self, animated: true)
}



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

func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
}
}

     


