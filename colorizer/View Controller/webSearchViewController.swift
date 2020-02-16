//
//  webSearchViewController.swift
//  colorizer
//
//  Created by Nandan on 09/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import WebKit

class webSearchViewController: UIViewController {

@IBOutlet weak var Webber: WKWebView!
override func viewDidLoad() {
        super.viewDidLoad()
     var string = (discoveredColor?.name)!
     string = string.replacingOccurrences(of: " ", with: "+")
     print(string)
     let url = URL(string: "https://www.amazon.in/s?k=\(string)+watercolor")
     let request = URLRequest(url: url!)
     Webber.load(request)

        // Do any additional setup after loading the view.
    }
@IBAction func Backer(_ sender: Any) {
performSegue(withIdentifier: "GoGoHikashi", sender: self)
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
