//
//  CreateListVC.swift
//  Invited
//
//  Created by ShayanSolutions on 5/22/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.

//  version2.2

import UIKit
import Contacts
import SQLite3
import PGSideMenu

class ContactData: NSObject
{
    var userID = String()
    var name = String()
    var phone = String()
    var email = String()
    var desc = String()
    var photo = String()
    var phoneNumber = String()
    var isSelected = Bool()
    var confirmed = Int()
    
}

extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}


@available(iOS 9.0, *)
class CreateListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var contactListTableView: UITableView!
    
    @IBOutlet var bottomViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet var mainView: UIView!
    
//    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var setListNameTextField: UITextField!
    
//    var results = [CNContact]()
    var deviceContactList = [ContactData]()
    var filteredList = [ContactData]()
    var selectedContactList = [ContactData]()
    var updatedContactList = [ContactData]()
    
//    var activeField : UITextField!
    
    var isUpdated : Bool!
    
    var isAllContactsSelected : Bool!
    
    var listData : UserList!
    
    var json : [String : Any]?
    
    
    @IBOutlet var unselectAllButton: UIButton!
    
    @IBOutlet var selectAllButton: UIButton!
    
    
    @IBOutlet var createButton: UIButton!
    
    @IBOutlet var updateButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.isAllContactsSelected = false
        
        self.searchTextField.addTarget(self, action: #selector(self.searchRecordsAsPerText(_:)), for: .editingChanged)
        
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//
//    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        if self.isUpdated == true
        {
            self.createButton.isHidden = true
            self.updateButton.isHidden = false
            
            self.setListNameTextField.text = self.listData.name
        }
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //        self.fetchAllContactsFromDevice()
        
        
        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
            if (!granted){
                
                BasicFunctions.showSettingsAlert(vc: self, msg: "Invited requires access to your contacts. Please allow it in Settings.")
            }
            else
            {
                if kContactList.count == 0
                {
                    BasicFunctions.query()
                }
                
            }
        })
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.checkUpdate()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.bottomView.layer.cornerRadius = 10.0
//        self.bottomView.clipsToBounds = true
//
//        self.bottomView.layer.borderWidth = 1.0
//        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        
        BasicFunctions.setLeftPaddingOfTextField(textField: self.setListNameTextField, padding: 10.0)
        BasicFunctions.setLeftPaddingOfTextField(textField: self.searchTextField, padding: 10.0)
    }
    @IBAction func selectAllButtonTapped(_ sender: UIButton)
    {
        self.selectAllButton.isHidden = true
        self.unselectAllButton.isHidden = false
        
        self.selectedContactList.removeAll()
        self.selectedContactList = self.filteredList
        self.contactListTableView.reloadData()
        
    }
    
    @IBAction func unselectAllButtonTapped(_ sender: UIButton)
    {
        self.selectAllButton.isHidden = false
        self.unselectAllButton.isHidden = true
        
        self.selectedContactList.removeAll()
        self.contactListTableView.reloadData()
    }
    
    
    
//    func fetchContactsFromDB(){
//
//        let queryString = "SELECT * FROM Contacts"
//
//        var stmt:OpaquePointer?
//
//        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
//        }
//
//        while(sqlite3_step(stmt) == SQLITE_ROW){
//            let name = String(cString: sqlite3_column_text(stmt, 1))
//            let phone = String(cString: sqlite3_column_text(stmt, 2))
//
//            let contactData = ContactData()
//            contactData.name = name
//            contactData.phoneNumber = phone
//            self.deviceContactList.append(contactData)
//        }
//
//        if sqlite3_finalize(stmt) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error finalizing prepared statement: \(errmsg)")
//        }
//
//        stmt = nil
//
//        if sqlite3_close(db) != SQLITE_OK {
//            print("error closing database")
//        }
//
//        db = nil
//
//        self.checkUpdate()
//    }
    func checkUpdate()  {
        
        if kContactList.count > 0
        {
            self.deviceContactList = kContactList
        
        if self.isUpdated == true
        {
        
//        for contactData in self.deviceContactList
//        {
//
//            for contact in self.listData.contactList
//            {
//
////            if contactData.phoneNumber.stringByRemovingWhitespaces ==  contact.phoneNumber.stringByRemovingWhitespaces
//
//            if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) })
//            {
//
//                break
//            }
//            else if contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) ==  contact.phoneNumber.stringByRemovingWhitespaces.suffix(9)
//            {
////                contactData.isSelected = true
//                self.selectedContactList.append(contactData)
//                break
//
//            }
//
//
//            }
//
//
////            if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
////            {
////
////
////            }
////            else
////            {
////                self.filteredList.append(contactData)
////            }
//
//
//        }
            
            for contact in self.listData.contactList
            {
                
                if self.deviceContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contact.phoneNumber.stringByRemovingWhitespaces.suffix(9) })
                {
                    
                    self.selectedContactList.append(contact)
                    
                }
                else
                {
                    self.selectedContactList.append(contact)
                }
            }
            
//            self.updatedContactList = self.filteredList.sorted { $0.name < $1.name }
//            self.filteredList.removeAll()
            
            
            
            
//            for contact in self.listData.contactList
//            {
//                self.selectedContactList.append(contact)
//            }
            
        }
//        else
//        {
        
            self.updatedContactList = self.deviceContactList.sorted { $0.name < $1.name }
//            self.filteredList.removeAll()
            
            
//        }
//        self.filteredList = self.updatedContactList
        
//        for contactdata in self.updatedContactList
//        {
//            if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactdata.phoneNumber.stringByRemovingWhitespaces.suffix(9) }) && self.filteredList.contains(where: { $0.name == contactdata.name })
//            {
//
//            }
//            else
//            {
//                self.filteredList.append(contactdata)
//            }
//
//        }
        
//        self.updatedContactList.removeAll()
        self.filteredList = self.updatedContactList
        
        self.contactListTableView.reloadData()
        
    }
        
    }
    
    
    @IBAction func backButtonSelected(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        self.filteredList.removeAll()
        if textfield.text?.count != 0
        {
            for contactData in self.updatedContactList {
                let textRange = contactData.name.lowercased().range(of: textfield.text!.lowercased(), options: .caseInsensitive, range: nil,   locale: nil)
                let phoneRange = contactData.phoneNumber.range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)
                

                if textRange != nil || phoneRange != nil
                {
                    
//                    if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
//                    {
//
//                    }
//                    else
//                    {
                        self.filteredList.append(contactData)
//                    }
                }
            }
        } else {
            
//            for contactData in self.updatedContactList {
//
//
//                if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
//                {
//
//                }
//                else
//                {
                    self.filteredList = self.updatedContactList
//                }
            
                
                
//            }
        
        }

        self.contactListTableView.reloadData()
    }
    
//    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
//        self.filteredList.removeAll()
//        if textfield.text?.count != 0 {
//            for contactData in self.updatedContactList {
//                let isMachingWorker : NSString = (contactData.name) as NSString
//                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
//                if range != nil {
//                    self.filteredList.append(contactData)
//                }
//            }
//        } else {
//            self.filteredList = self.updatedContactList
//        }
//        self.contactListTableView.reloadData()
//    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as? ContactCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("ContactCell", owner: nil, options: nil)?[0] as? ContactCell
        }
        
        cell?.deleteButton.isHidden = true
        
        
        let contactData = self.filteredList[indexPath.row]
        
        if contactData.name == " "
        {
            
            cell?.nameLabel.text = contactData.phoneNumber
        }
        else
        {
            cell?.nameLabel.text = String(format: "%@ (%@)", contactData.name,contactData.phoneNumber)
        }
        
        if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) })
        {
            cell?.selectedIcon.isHidden = false
        }
        else
        {
            cell?.selectedIcon.isHidden = true
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell : ContactCell = tableView.cellForRow(at: indexPath) as! ContactCell
        
        let contactData = self.filteredList[indexPath.row]
        
        if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) })
        {
//            contactData.isSelected = false
            cell.selectedIcon.isHidden = true
            
//            self.filteredList[indexPath.row]  = contactData
//            self.updatedContactList[indexPath.row]  = contactData
            
//            if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) })
//            {
                let index = self.selectedContactList.index{$0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9)}
                self.selectedContactList.remove(at: index!)
                
//            }
        }
        else
        {
//            contactData.isSelected = true
            
            if contactData.phoneNumber.isEmpty
            {
                BasicFunctions.showAlert(vc: self, msg: "This contact has no phone number")
                return
            }
            
            cell.selectedIcon.isHidden = false
//            self.filteredList[indexPath.row]  = contactData
//            self.updatedContactList[indexPath.row]  = contactData
            self.selectedContactList.append(contactData)
        }
        
    }
    
    
    @IBAction func createButtonTapped(_ sender: UIButton)
    {
        
        if (self.setListNameTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Plese put name of the list.")
            return
        }
        else if self.selectedContactList.count == 0
        {
            BasicFunctions.showAlert(vc: self, msg: "Plese add contacts")
            return
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.createList), userInfo: nil, repeats: false)
        

    }
    @objc func createList()
    {
        var postParams = [String : Any]()
        postParams["contact_list"] = self.convertSelectedDataintoJson()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["list_name"] = self.setListNameTextField.text
        
        
        ServerManager.createList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String : Any]
            //            let msg = json!["message"] as? String
            
            let status = json!["status"] as? String
            
            let message = json!["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if json!["error"] == nil && status == "success"
            {
                let msg = json!["messages"] as? String
                
                kUserList.removeAll()
                
                self.dismiss(animated: true, completion: nil)
                
                if msg != nil
                {
                    BasicFunctions.showAlert(vc: self, msg: msg)
                }
            }
            else
            {
                
                BasicFunctions.showAlert(vc: self, msg: message)
            }
            
            
        }
        
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton)
    {
        if (self.setListNameTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Plese put name of the list.")
            return
        }
        else if self.selectedContactList.count == 0
        {
            BasicFunctions.showAlert(vc: self, msg: "Plese add contacts")
            return
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateList), userInfo: nil, repeats: false)
        
        
    }
    @objc func updateList()
    {
        var postParams = [String : Any]()
        postParams["contact_list"] = self.convertSelectedDataintoJson()
        postParams["list_id"] = self.listData.id
        postParams["list_name"] = self.setListNameTextField.text
        
        ServerManager.updateList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let msg = json["messages"] as! String
            
            let message = json["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if json["error"] == nil
            {
                kUserList.removeAll()
                self.dismissVC()
                BasicFunctions.showAlert(vc: self, msg: msg)
            }
            
        }
    }
    func dismissVC()
    {
        if self.listData != nil
        {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let navController = (appDelegate?.window?.rootViewController as? PGSideMenu)?.contentController as? UINavigationController
            
            //                var navigationArray = navController?.viewControllers
            
            var presentViewcontroller : ListDetailVC!
            
            for controller in (navController?.viewControllers)!
            {
                if controller is ListDetailVC
                {
                    presentViewcontroller = controller as? ListDetailVC
                    break
                }
            }
            
            self.listData.name = self.setListNameTextField.text!
            self.listData.contactList = self.selectedContactList
            
            presentViewcontroller.listData = self.listData
        }
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func convertSelectedDataintoJson() -> String
    {
        
        var jsonFormSelectedContactList = [[String : Any]]()
    
        for contact in self.selectedContactList
        {
            var contactDic = [String: Any]()
            contactDic["name"] = BasicFunctions.getNameFromContactList(phoneNumber: contact.phoneNumber)
        
            contactDic["phone"] = contact.phoneNumber.stringByRemovingWhitespaces
            
            
            jsonFormSelectedContactList.append(contactDic)
            
        }
        
        let jsonString = self.convertToJsonString(from: jsonFormSelectedContactList)
        
        
        return jsonString!
    }
    func convertToJsonString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
//    {
//
////        self.activeField = textField
//
//        return true
//
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            
//            if self.activeField.tag == 2
//            {
//                if #available(iOS 11.0, *) {
//                    self.bottomViewConstraint.constant = keyboardSize.height + self.view.safeAreaInsets.bottom
//                } else {
//                    // Fallback on earlier versions
//                    
//                    self.bottomViewConstraint.constant += keyboardSize.height
//                    
//                }
//            }
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            
//            if self.bottomViewConstraint.constant != 10
//            {
//            
//            self.bottomViewConstraint.constant = 10
//            }
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
