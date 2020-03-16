//
//  LoginViewController.swift
//  colorizer
//
//  Created by Sumant Sogikar on 21/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
var emailu : String = ""
var fromSetting = false
var fromWeb = false
class LoginViewController: UIViewController {
@IBOutlet weak var EmailTF: UITextField!

@IBOutlet weak var SkipBut: UIButton!
@IBOutlet weak var SignBut: UIButton!
@IBOutlet weak var LogBut: UIButton!
@IBOutlet weak var PasswordTF: UITextField!
@IBOutlet weak var LoginTF: UITextField!
@IBOutlet weak var PassTF: UITextField!
@IBOutlet weak var forgottenPassword: UIButton!
//Used for gradient background
let gradientLayer = CAGradientLayer()

override func viewDidLoad() {
        super.viewDidLoad()
let vc = LangViewController()
let val = vc.defaultLang
if val == true{
self.languageShower(selectedlang: "en")
}
else{
self.languageShower(selectedlang: "ja")
}

//Used for gradient background
gradientLayer.frame = self.view.bounds
gradientLayer.colors = [UIColor(red: 8/255, green: 164/255, blue: 233/255, alpha: 1).cgColor, UIColor(red: 0/255, green: 194/255, blue: 179/255, alpha: 1).cgColor,UIColor.white.cgColor]
self.view.layer.insertSublayer(gradientLayer, at: 0)
//Secure entry of password
PasswordTF.isSecureTextEntry = true
//Begins the observation using firebase
Auth.auth().addStateDidChangeListener() { auth, user in
  if user != nil {
   
    self.EmailTF.text = nil
    self.PasswordTF.text = nil
  }
}
        // Do any additional setup after loading the view.
    }

override func viewDidAppear(_ animated: Bool) {
super.viewDidAppear(true)
//Checks if user is loggedIn or not
if Auth.auth().currentUser != nil {
print("\(String(describing: Auth.auth().currentUser?.email)) SOS")
LoggedIn = true
    self.performSegue(withIdentifier: "LoginDone", sender: self)
}
}
//Language Displayer
func languageShower(selectedlang:String){
EmailTF.placeholder = "Email".localisableString(loc: selectedlang)
PassTF.placeholder = "Password".localisableString(loc: selectedlang)
LogBut.setTitle("Login".localisableString(loc: selectedlang), for: .normal)
SignBut.setTitle("SignUp".localisableString(loc: selectedlang), for: .normal)
SkipBut.setTitle("Skip".localisableString(loc: selectedlang), for: .normal)
}
//SignUp Button
@IBAction func SignUpTouched(_ sender: Any) {
 let alert = UIAlertController(title: "Register to our site",
                                  message: "Enter the below details to register and use our app to its fullest extent",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Register", style: .default) { _ in
      
      let emailField = alert.textFields![0]
      let passwordField = alert.textFields![1]
    let secondPF = alert.textFields![2]
    //Some criterians to be fulfilled to logIn
    if (emailField.text?.count)! > 0 && (passwordField.text?.count)! > 7{
    if passwordField.text! == secondPF.text!{
    //Creates User in Firebase
      Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
        if error == nil {
        //Storing email data into a variable
        emailu = Auth.auth().currentUser?.email ?? ""
        //Signs In the USer
          Auth.auth().signIn(withEmail: self.EmailTF.text!,
                             password: self.PasswordTF.text!)
        }
        else{
        //If SignIn Fails
         let alerter = UIAlertController(title: "Error",
        message: "Please Try Again with a different email id and/or password",
        preferredStyle: .alert)
        let okay = UIAlertAction(title: "Ok",
        style: .cancel)
        alerter.addAction(okay)
        self.present(alerter, animated: true, completion: nil)
      }
      }
    }
    else {
    //If passwords arent same
     let alerter = UIAlertController(title: "Error",
    message: "Passwords don't match.",
    preferredStyle: .alert)
    let okay = UIAlertAction(title: "Ok",
    style: .cancel)
    alerter.addAction(okay)
    self.present(alerter, animated: true, completion: nil)
    
    }
    }
    else{
    //If criterians arent fulfilled
     let alerter = UIAlertController(title: "Error",
    message: "Please Try Again with a different email id and/or password",
    preferredStyle: .alert)
    let okay = UIAlertAction(title: "Ok",
    style: .cancel)
    alerter.addAction(okay)
    self.present(alerter, animated: true, completion: nil)
    
    }
}
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email (Ex.:abc@pqr.com)"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password (min 8 char)"
    }
alert.addTextField { textSecPassword in
  textSecPassword.isSecureTextEntry = true
  textSecPassword.placeholder = "Enter your password again"
}

    
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    present(alert, animated: true, completion: nil)
  }


//LogIn Button
@IBAction func LoginTouched(_ sender: Any) {
guard
     let email = EmailTF.text,
     let password = PasswordTF.text,
     email.count > 0,
     password.count > 0
     else {
       return
   }

   //SignsIn
   Auth.auth().signIn(withEmail: email, password: password) { user, error in
     if let error = error, user == nil {
       let alert = UIAlertController(title: "Sign In Failed",
                                     message: error.localizedDescription,
                                     preferredStyle: .alert)
       
       alert.addAction(UIAlertAction(title: "OK", style: .default))
       
       self.present(alert, animated: true, completion: nil)
     }
     else{
     emailu = Auth.auth().currentUser?.email ?? ""
     LoggedIn = true
     self.performSegue(withIdentifier: "LoginDone", sender: self)
   }
 }
}
//Skips i.e. no signIn nor signUp happens
@IBAction func Skipper(_ sender: Any) {
if fromWeb == true{
fromSetting = false
self.performSegue(withIdentifier: "BackToWeb", sender: self)
}
if fromSetting == true{
fromWeb = false
self.performSegue(withIdentifier: "BackToHalf", sender: self)
}
}

@IBAction func Forgot(_ sender: Any) {
let alert = UIAlertController(title: "Password Reset", message:  "Enter your emailID to recieve the reset link.", preferredStyle: .alert)
alert.addTextField { textEmail in
  textEmail.placeholder = "Enter your email (Ex.:abc@pqr.com)"
}
let sendAction = UIAlertAction(title: "Send", style: .default) { _ in let email = alert.textFields![0]
Auth.auth().sendPasswordReset(withEmail: email.text!, completion: { (error) in
if error != nil{
               let resetFailedAlert = UIAlertController(title: "Password Reset Failed", message: "Consider trying again with a different emailID", preferredStyle: .alert)
               resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(resetFailedAlert, animated: true, completion: nil)
}})

}
let cancelAction = UIAlertAction(title: "Cancel",
                                 style: .default)
alert.addAction(cancelAction)
alert.addAction(sendAction)
present(alert,animated: true,completion: nil)
}


/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
