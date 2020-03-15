//
//  webSearchViewController.swift
//  colorizer
//
//  Created by Nandan on 09/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase
class webSearchViewController: UIViewController {
//Using a webView to display our client's site
@IBOutlet weak var Webber: WKWebView!
var ref : DatabaseReference!
override func viewDidLoad() {
        super.viewDidLoad()
var string = (dataBaseColor.name)
//Converting color name into url format
     string = string.replacingOccurrences(of: " ", with: "+")
     print(string)
     let url = URL(string: "https://www.amazon.in/s?k=\(string)+watercolor")
     let request = URLRequest(url: url!)
//Loading the URL
     Webber.load(request)

        // Do any additional setup after loading the view.
    }
//Back button
@IBAction func Backer(_ sender: Any){
let alerter = UIAlertController(title: "Purchased A Product?",
message: "If you did,Click on Yes and enter your full name",
preferredStyle: .alert)
let Yes = UIAlertAction(title: "Yes",
                        style: .default,handler: { (action : UIAlertAction!) in
                       guard let textField = alerter.textFields?.first,
                       let text = textField.text else { return }
                        //Stores the details of purchased users(for cross referencing that aids in revenue)into firebase
                       self.ref = Database.database().reference().child("Purchased Product Details")
                       let data : NSDictionary = ["Name" : text.uppercased(), "Email" : emailu ]
                       let nameref = self.ref.child((discoveredColor?.name)!)
                       nameref.setValue(data)
                       
                       self.performSegue(withIdentifier: "GoGoHikashi2", sender: self)})
 
alerter.addTextField { textfield in
  textfield.placeholder = "Enter your Full Name."
}

alerter.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
//Stores the details of Viewers(for cross referencing that aids in revenue)into firebase
self.ref = Database.database().reference().child("Web Traffic Count")
let data : NSDictionary = ["Email" : emailu ]
let nameref = self.ref.child((discoveredColor?.name)!)
nameref.setValue(data)
self.performSegue(withIdentifier: "GoGoHikashi2", sender: nil)
}))
alerter.addAction(Yes)
 self.present(alerter, animated: true, completion: nil)


}



}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//func AlertShower(){
//let alerter = UIAlertController(title: "Purchased A Product?",
//   message: "If you did,Click on Yes.",
//   preferredStyle: .alert)
//
//   let Yes = UIAlertAction(title: "YES",
//                            style: .cancel){ _ in
//                            self.ref = Database.database().reference().child("Purchased User")
//                            let data : NSDictionary = ["Name" : email, "Email" : email]
//                            self.ref.childByAutoId().setValue(data){
//                            (error,ref) in
//                            if error == nil{
//                            print("YES")
//                            }
//                            else{
//                            print("NO")
//                            }
//
//                            }
//
//}
//let No = UIAlertAction(title: "NO",
//                       style: .cancel)
//   alerter.addAction(Yes)
//alerter.addAction(No)
//   self.present(alerter, animated: true, completion: nil)
//}
