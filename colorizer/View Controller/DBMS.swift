//
//  DBMS.swift
//  colorizer
//
//  Created by B M PRATEEK KUSHALAPPA on 12/02/20.
//  Copyright © 2020 Nandan. All rights reserved.
//

import UIKit
import SQLite
import Firebase

class modelManger {
var name : String?
var hexCode : String?


init(name : String , hexCode : String) {
self.name = name
self.hexCode = hexCode
}

}

class DBMS : UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate
{

var values = [modelManger]()
var searchData = [modelManger]()


//table view
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return searchData.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


  let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
let mm : modelManger
mm =  searchData[indexPath.row]
cell.nameCellLabel.text = mm.name
cell.hexCodeCellLabel.text = mm.hexCode
cell.colorIndicator.layer.masksToBounds = true
cell.colorIndicator.layer.cornerRadius = 30
cell.colorIndicator.backgroundColor = UIColor(hex: mm.hexCode ?? UIColor.clear.hexString)
return cell

}

   //readValues
func readValues()
{
values.removeAll()

do
{
let users = try self.database.prepare(self.usersTable)
for user in users
{
let n = String(user[self.name] ?? "")
let h = String(user[self.hexCode])
values.append(modelManger(name: n, hexCode: h))

}

print("successfull displaying the table")
}
catch
{
print("error in displaying the table")
}





listusers()

self.tableView.reloadData()

}


var textfield1 : String?
var hexcode = dataBaseColor.hexString
var Name = dataBaseColor.name
var database : Connection!
let usersTable = Table("users")
var editTextfield : String = ""
let name = Expression<String?>("name")
let hexCode = Expression<String>("hexCode")
var nm : String = ""
var hc : String = ""
//let id = Expression<Int>("id")
//viewDidLoad

override func viewDidLoad() {
super.viewDidLoad()
tableView.rowHeight = 50
cC.isHidden = true
chosenColorButton.clipsToBounds = true
chosenColorButton.layer.cornerRadius = 30
chosenColorButton.backgroundColor = dataBaseColor
chosenColorButton.titleLabel?.textColor = .label
chosenColorButton.titleLabel?.text = "Tap here to save"
if UIColor(hex: self.hexcode).isDarkColor{
chosenColorButton.setTitleColor(.white, for: .normal)
}
else{
chosenColorButton.setTitleColor(.black, for: .normal)
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
let createTable = self.usersTable.create { (table) in
 table.column(self.name, unique: true)
table.column(self.hexCode, primaryKey: true)
}
do
{
try self.database.run(createTable)
print("created table")

}
catch
{
print("error creating the table")
}

tableView.delegate = self
tableView.dataSource = self
searchBar.delegate = self

readValues()

searchData = values


}

override func viewDidAppear(_ animated: Bool) {
 
chosenColorButton.isUserInteractionEnabled = true
}
 

@IBAction func saver3(_ sender: UIButton) {
 

let alert = UIAlertController(title: "Want to insert \(hexcode ) ? ", message: "Would you like to save this data?", preferredStyle: UIAlertController.Style.alert)
let InsertAction = UIAlertAction(title: "Save", style: .default) { (alertAction) in
  let textField = alert.textFields![0] as UITextField
self.textfield1 = textField.text
print("insert tapped")

guard !(self.textfield1?.isEmpty ?? true) else
{
let alertcontroller:UIAlertController = UIAlertController(title: " Error Inserting Data", message: " Please enter the appropriate colour name / hexcode", preferredStyle:  UIAlertController.Style.alert)
       let alertAction:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:nil)
       alertcontroller.addAction(alertAction)

self.present(alertcontroller, animated: true, completion: nil)

return

}
let insertUser = self.usersTable.insert(self.name <- self.textfield1, self.hexCode <- self.hexcode )
              do
              {
              try self.database.run(insertUser)
              print("inserted user")
              self.listusers()
             }
             catch
             {
             print("error inserting the user")
             }

self.readValues()
self.searchData = self.values
self.tableView.reloadData()
self.chosenColorButton.isUserInteractionEnabled = false
self.chosenColorButton.isHidden = true
self.cC.isHidden = false
self.cC.text = dataBaseColor.name


return
}

        alert.addTextField { (textField) in
        textField.placeholder = "Enter the name"
        textField.text = self.Name
        }
          
let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
print("cancel button tapped")
}
alert.addAction(cancelAction)
alert.addAction(InsertAction)
present(alert , animated: true , completion: nil)

}

func listusers()
{
print("list tapped")
do{
let users = try self.database.prepare(self.usersTable)
for user in users
{
print("user name : \(user[self.name] ?? "") hexcode : \(user[self.hexCode])")

}

}
catch
{
print("error showing the list")
}
return
}


@IBAction func shareButton(_ sender: Any) {
 
var bro1 = "Color Name : \((cC.text) ?? dataBaseColor.name) \n Hexcode : \((dataBaseColor.hexString)) \n Values : (\(Int(dataBaseColor.components.red * 255)) , \(Int(dataBaseColor.components.green * 255)) ,\(Int(dataBaseColor.components.blue * 255)) )"
if !truth {
let bro = "Color Name : \((cC.text) ?? dataBaseColor.name) \n Hexcode : \((dataBaseColor.hexString)) \n Values : (\(Int(dataBaseColor.hsba.hue * 100)) , \(Int(dataBaseColor.hsba.saturation * 100)) ,\(Int(dataBaseColor.hsba.brightness * 100)) )"
 bro1 = bro
}
let SharingVC = UIActivityViewController(activityItems: [bro1], applicationActivities: nil)

  if let pop = SharingVC.popoverPresentationController{
  pop.sourceView = self.view
  pop.sourceRect = (sender as AnyObject).frame

  }
  self.present(SharingVC, animated: true, completion: nil)

}

 
 @IBOutlet weak var tableView: UITableView!


func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
return true
}

func tableView(_ tableView: UITableView,
                trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
 {
     
 let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
 let valueName = cell.nameCellLabel.text
 let valueHex = cell.hexCodeCellLabel.text
 dataBaseColor = UIColor(hex: valueHex ?? "ffffff")
 
 
 self.nm = valueName ?? ""
 self.hc = valueHex ?? ""
 let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
     success(true)
 print("delete tapped")
 self.searchData.remove(at: indexPath.row)
 tableView.deleteRows(at: [indexPath], with: .fade)

 
 let user = self.usersTable.filter(self.name == self.nm)
 let deleteUser = user.delete()
 do{
 try self.database.run(deleteUser)

 print("deleted user")
 self.readValues()
 self.listusers()
 }
 catch{
 print("error deleting the table")
 }
 self.readValues()
 self.searchData = self.values
 self.tableView.reloadData()
 
 })
 deleteAction.backgroundColor = .red

 return UISwipeActionsConfiguration(actions: [deleteAction])

        
 }
func tableView(_ tableView: UITableView,
                leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
 {
 
 
 let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
 let valueName = cell.nameCellLabel.text
 let valueHex = cell.hexCodeCellLabel.text
 self.nm = valueName ?? ""
 self.hc = valueHex ?? ""
 
     let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             success(true)
     

     let alert = UIAlertController(title: "UPDATE \(self.hc ) ? ", message: "would you like to update this data?", preferredStyle: UIAlertController.Style.alert)
     let EditAction = UIAlertAction(title: "Save", style: .default) { (alertAction) in
       let textField = alert.textFields![0] as UITextField
     self.editTextfield = textField.text ?? ""
     print("update tapped")
     let user = self.usersTable.filter(self.name == self.nm)
     let editUser = user.update(self.name <- self.editTextfield)
    do
    {
    try self.database.run(editUser)
    self.readValues()
    print("successfully updated user")
     }
     catch
     {
     print("error updating")
     }
     self.readValues()
     self.searchData = self.values
     self.tableView.reloadData()
     }

             alert.addTextField { (textField) in
             textField.placeholder = "Enter your name"
             textField.text = self.nm
             }
          
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
     print("cancel button tapped")
     }
     alert.addAction(cancelAction)
     alert.addAction(EditAction)
     self.present(alert , animated: true , completion: nil)
     
     
     
     
     
     
     
     
     
     
     
     
         })
editAction.backgroundColor = .blue

         return UISwipeActionsConfiguration(actions: [editAction])
 }



@IBOutlet weak var chosenColorButton: UIButton!

@IBOutlet weak var cC: UILabel!

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
dataBaseColor = UIColor(hex: cell.hexCodeCellLabel.text ?? "#000000")
discoveredColor = dataBaseColor
chosenColorButton.isHidden = true
cC.isHidden = false
cC.text = cell.nameCellLabel.text ?? discoveredColor?.name

 tt = true
}
 

 

// search bar

@IBOutlet weak var searchBar: UISearchBar!

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
readValues()
guard !searchText.isEmpty else
{
searchData = values
tableView.reloadData()
return

}
searchData = values.filter({  value -> Bool in
guard let text = searchBar.text else { return false}
guard let value = value.name?.lowercased().contains(text.lowercased()) else { return false}
tableView.reloadData()
return value

})
tableView.reloadData()
}

func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

searchBar.text = ""
searchData = values

searchBar.resignFirstResponder()
tableView.reloadData()
}
 

@IBAction func purchaser(_ sender: Any) {
//if Auth.auth().currentUser != nil{
//performSegue(withIdentifier: "GoGoHikashi", sender: self)
//}
//else{
//let alert = UIAlertController(title: "Not Logged In", message: "Login to access more features", preferredStyle: .alert)
//let login = UIAlertAction(title: "LogIn", style: .default, handler: { _ in
//fromWeb = true
//self.performSegue(withIdentifier: "LogWeb", sender: self)
//})
//let NotNow = UIAlertAction(title: "Not Now", style: .default, handler: { _ in
//self.performSegue(withIdentifier: "GoGoHikashi", sender: self)
//})
//alert.addAction(login)
//alert.addAction(NotNow)
//self.present(alert, animated: true, completion: nil)
//}
}


}

