//
//  EventViewController.swift
//  colorizer
//
//  Created by Sumant Sogikar on 23/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import FirebaseDatabase
class EventViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
@IBOutlet weak var tableView: UITableView!
@IBOutlet weak var LoadingLab: UILabel!
//A database reference and handle necessary to check and use firebase realtime database
var ref : DatabaseReference?
var dbh : DatabaseHandle?
var event : [String] = []
override func viewDidLoad() {
        super.viewDidLoad()
tableView.delegate = self
tableView.dataSource = self
//Declaring the reference database
ref = Database.database().reference()
//Observing the "Event" child in the database
dbh = ref?.child("Events").observe(.childAdded, with: { (snapshot) in
let post = snapshot.value as? String
if let apost = post{
//Adds the events to our defined array
self.event.append(apost)
//reloads the table to dispaly the data
self.tableView.reloadData()
//"Loading..." label changes itself to "Events"
self.LoadingLab.text = "Events"
}
})}
//Basic necessary tableView functions below
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return event.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
    if cell == nil {
    cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
    }
    if self.event.count > 0 {
    //Displaying the event
        cell?.textLabel!.text = self.event[indexPath.row]
    }
//cell UI codes
    cell?.textLabel?.numberOfLines = 0
cell?.backgroundColor = .systemOrange
cell?.layer.borderWidth = 1
cell?.layer.cornerRadius = 8
cell?.clipsToBounds = true
    return cell!
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
}
//Back Button
@IBAction func Backer11(_ sender: Any) {
self.performSegue(withIdentifier: "Unwinder1122", sender: self)
}
// Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


