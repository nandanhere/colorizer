//
//  LangViewController.swift
//  colorizer
//
//  Created by Sumant Sogikar on 05/03/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit

class LangViewController: UIViewController, UITableViewDelegate , UITableViewDataSource  {
//UserDefault for setting the input for language
var defaultLang = UserDefaults().bool(forKey: "EN")
var en:Bool = true
var ja:Bool = false

@IBOutlet weak var tableView: UITableView!
//Language Array (4 spaces given so that the placement is proper in UILabel
var Array:[String] = ["    English","    Japanese"]
//Basic tableView functions below
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return Array.count
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
tableView.estimatedRowHeight = 85.0
tableView.rowHeight = UITableView.automaticDimension
return tableView.rowHeight
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//english Bool takes the default user values
en = defaultLang
  let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
cell.textLabel?.text = self.Array[indexPath.row]
cell.backgroundColor = UIColor(red: 251/255, green: 229/255, blue: 119/255, alpha: 1)
cell.textLabel?.numberOfLines = 0
cell.layer.borderWidth = 1
cell.clipsToBounds = true
return cell

}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
let cell = tableView.cellForRow(at: indexPath)

//if english is selected
if indexPath.row == 0{
UserDefaults().set(true, forKey: "EN")
ja = false
cell?.backgroundColor = .lightGray

}
//if japanese is selected
else if indexPath.row == 1{
print(1)
UserDefaults().set(false, forKey: "EN")
ja = true
cell?.backgroundColor = .lightGray
}
}
override func viewDidLoad() {
        super.viewDidLoad()
self.tableView.dataSource = self
          self.tableView.delegate = self
print(en)
        // Do any additional setup after loading the view.
    }
//Back Button
@IBAction func Backed(_ sender: Any) {
print("Done")
performSegue(withIdentifier: "UnwindSett", sender: self)
}

//@IBAction func Backer(_ sender: Any) {
//performSegue(withIdentifier: "UnwindSett", sender: self)
//}

  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
