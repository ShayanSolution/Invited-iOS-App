//
//  CreateListVC.swift
//  Invited
//
//  Created by ShayanSolutions on 5/22/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import Contacts

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
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var setListNameTextField: UITextField!
    
    var results = [CNContact]()
    var contactList = [ContactData]()
    var filteredList = [ContactData]()
    var selectedContactList = [ContactData]()
    var updatedContactList = [ContactData]()
    
    var activeField : UITextField!
    
    var isUpdated : Bool?
    
    var listData : UserList!
    
    
    @IBOutlet var createButton: UIButton!
    
    @IBOutlet var updateButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.searchTextField.addTarget(self, action: #selector(self.searchRecordsAsPerText(_:)), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if self.isUpdated == true
        {
            self.createButton.isHidden = true
            self.updateButton.isHidden = false
            
            self.setListNameTextField.text = self.listData.name
            
            
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.fetchAllContactsFromDevice()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.bottomView.layer.cornerRadius = 10.0
        self.bottomView.clipsToBounds = true
        
        self.bottomView.layer.borderWidth = 1.0
        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        
        BasicFunctions.setLeftPaddingOfTextField(textField: self.setListNameTextField, padding: 10.0)
        BasicFunctions.setLeftPaddingOfTextField(textField: self.searchTextField, padding: 10.0)
    }
    
    func fetchAllContactsFromDevice()  {
         if #available(iOS 9.0, *) {
            var contacts: [CNContact] = {
                let contactStore = CNContactStore()
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactImageDataAvailableKey,
                    CNContactThumbnailImageDataKey] as [Any]
                
                // Get all the containers
                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch {
                    print("Error fetching containers")
                }
                
                
                
                // Iterate all containers and append their contacts to our results array
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    
                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        self.results.append(contentsOf: containerResults)
//                        self.storeDataInModelObjects()
                    } catch {
                        print("Error fetching results for container")
                    }
                }
                self.storeDataInModelObjects()
                return self.results
            }()
        } else {
            // Fallback on earlier versions
        }
    }
    func storeDataInModelObjects()  {
        for contact in self.results
        {
            let contactData = ContactData()
            contactData.name = contact.givenName + " " + contact.familyName
//            contactData.phoneNumber = ((contact.phoneNumbers.first?.value)?.stringValue)!
            if contact.isKeyAvailable(CNContactPhoneNumbersKey){
                let phoneNOs=contact.phoneNumbers
                for item in phoneNOs
                {
                    contactData.phoneNumber = item.value.stringValue
                }
            }
            
            
            self.contactList.append(contactData)
        }
        
        if self.isUpdated == true
        {
        
        for contactData in self.contactList
        {
            
            for contact in self.listData.contactList
            {
            
//            if contactData.phoneNumber.stringByRemovingWhitespaces ==  contact.phoneNumber.stringByRemovingWhitespaces
                
            if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
            {
                
                break
            }
            else if contactData.phoneNumber.stringByRemovingWhitespaces ==  contact.phoneNumber.stringByRemovingWhitespaces
            {
                contactData.isSelected = true
                self.selectedContactList.append(contactData)
                break
                
            }
                
            }
            
            if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
            {
            
            
            }
            else
            {
                self.filteredList.append(contactData)
            }
            
            
        }
            
            self.updatedContactList = self.filteredList.sorted { $0.name < $1.name }
            self.filteredList.removeAll()
            
            
            
            
//            for contact in self.listData.contactList
//            {
//                self.selectedContactList.append(contact)
//            }
            
        }
        else
        {
        
            self.updatedContactList = self.contactList.sorted { $0.name < $1.name }
            self.filteredList.removeAll()
            
            
        }
//        self.filteredList = self.updatedContactList
        
        for contactdata in self.updatedContactList
        {
            if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactdata.phoneNumber.stringByRemovingWhitespaces })
            {
                
            }
            else
            {
                self.filteredList.append(contactdata)
            }
            
        }
        self.contactListTableView.reloadData()
        
        
        
    }
    
    
    @IBAction func backButtonSelected(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        self.filteredList.removeAll()
        if textfield.text?.characters.count != 0 {
            for contactData in self.updatedContactList {
                let range = contactData.name.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil,   locale: nil)

                if range != nil {
                    
                    if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
                    {

                    }
                    else
                    {
                        self.filteredList.append(contactData)
                    }
                }
            }
        } else {
            
            for contactData in self.updatedContactList {
                
                
                if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
                {
                    
                }
                else
                {
                    self.filteredList.append(contactData)
                }
                
                
                
            }
            
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
        return filteredList.count
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
            cell?.nameLabel.text = contactData.name
        }
        
        if contactData.isSelected
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
        
        if contactData.isSelected
        {
            contactData.isSelected = false
            cell.selectedIcon.isHidden = true
            
            self.filteredList[indexPath.row]  = contactData
            self.updatedContactList[indexPath.row]  = contactData
            
            if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
            {
                let index = self.selectedContactList.index(of: contactData)
                self.selectedContactList.remove(at: index!)
                
            }
        }
        else
        {
            contactData.isSelected = true
            cell.selectedIcon.isHidden = false
            self.filteredList[indexPath.row]  = contactData
            self.updatedContactList[indexPath.row]  = contactData
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
        
        var postParams = [String : Any]()
        postParams["contact_list"] = self.convertSelectedDataintoJson()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["list_name"] = self.setListNameTextField.text
        
        ServerManager.createList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String : Any]
            let msg = json!["message"] as? String
            let status = json!["status"] as? String
            
            let message = json!["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if json!["error"] == nil && status == "success"
            {
                let msg = json!["messages"] as? String
                
                self.dismiss(animated: true, completion: nil)
                
                if msg != nil
                {
                BasicFunctions.showAlert(vc: self, msg: msg)
                }
            }
            else
            {
                BasicFunctions.showAlert(vc: self, msg: msg)
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
        
        var postParams = [String : Any]()
        postParams["contact_list"] = self.convertSelectedDataintoJson()
        postParams["list_id"] = self.listData.id
        postParams["list_name"] = self.setListNameTextField.text
        
        ServerManager.updateList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let msg = json["messages"] as! String
            
            let message = json["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if json["error"] == nil
            {
                
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
            let navController = appDelegate?.window?.rootViewController as? UINavigationController
            
            //                var navigationArray = navController?.viewControllers
            
            var presentViewcontroller : ListDetailVC!
            
            for controller in (navController?.viewControllers)!
            {
                if controller is ListDetailVC
                {
                    presentViewcontroller = controller as! ListDetailVC
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
            contactDic["name"] = contact.name
        
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        self.activeField = textField
        
        return true
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.activeField.tag == 2
            {
            self.bottomViewConstraint.constant += keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.bottomViewConstraint.constant != 10
            {
            
            self.bottomViewConstraint.constant = 10
            }
        }
    }
    
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
