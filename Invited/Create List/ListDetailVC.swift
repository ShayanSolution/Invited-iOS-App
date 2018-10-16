//
//  ListDetailVC.swift
//  Invited
//
//  Created by ShayanSolutions on 6/11/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit


class ListDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var contactListTableView: UITableView!
    
    var listData : UserList!
    
    var searchData : [ContactData]!
    
    
    
    
    @IBOutlet var searchTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.searchTextField.addTarget(self, action: #selector(self.searchRecordsAsPerText(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.searchData = self.listData.contactList
        
        
        self.contactListTableView.reloadData()
        
    }
    @objc func appDidBecomeActive()
    {
        self.contactListTableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        BasicFunctions.setLeftPaddingOfTextField(textField: self.searchTextField, padding: 10.0)
    }
    
    @objc func searchRecordsAsPerText(_ textfield:UITextField) {
        self.searchData.removeAll()
        if self.searchTextField.text?.count != 0 {
            for contactData in self.listData.contactList
            {
                let range = contactData.name.lowercased().range(of: textfield.text!.lowercased(), options: .caseInsensitive, range: nil,   locale: nil)
                
                if range != nil {
//
//                    if self.searchData.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
//                    {
//
//                    }
//                    else
//                    {
                        self.searchData.append(contactData)
                    }
//                }
            }
        } else {
            
//            for contactData in self.listData.contactList {
//
//
//                if self.filteredList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
//                {
//
//                }
//                else
//                {
                    self.searchData = self.listData.contactList
//                }
                
                
                
//            }
            
        }
        
        self.contactListTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as? ContactCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("ContactCell", owner: nil, options: nil)?[0] as? ContactCell
        }
        
        cell?.accessoryView?.isHidden = true
        
        let contactData = self.searchData[indexPath.row]
        
        cell?.deleteButton.tag = indexPath.row
        
        cell?.deleteButton.addTarget(self, action: #selector(self.deleteContact(sender:)), for: UIControlEvents.touchUpInside)
        
        let name = BasicFunctions.getNameFromContactList(phoneNumber: contactData.phoneNumber)
        
        if name == " "
        {
            
            cell?.nameLabel.text = contactData.phoneNumber
        }
        else
        {
            cell?.nameLabel.text = name + " " + "(" + contactData.phoneNumber + ")"
        }
        
        return cell!
        
        }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
//    {
//        
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        var editAction = UITableViewRowAction(style: .default, title: "", handler: { (action, indexPath) in
//
//
//
//        })
//
//        var deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
//
//            let contactData = self.searchData[indexPath.row]
//
//
//
//
//
////            if self.selectedContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces == contactData.phoneNumber.stringByRemovingWhitespaces })
////            {
//            if let index = self.listData.contactList.index(of: contactData)
//            {
//
//                self.listData.contactList.remove(at: index)
//
//            }
//
//
//            self.updateButtonTapped()
//
//
//
//        })
//
//        return[editAction,deleteAction]
//
//    }
    
    @objc func deleteContact(sender : UIButton)
    {
        let contactData = self.searchData[sender.tag]
        
        self.searchData.remove(at: sender.tag)
//        self.contactListTableView.deleteRows(at: [sender.tag], with: .automatic)
        if let index = self.listData.contactList.index(of: contactData)
        {
            
            self.listData.contactList.remove(at: index)
            
        }
        
        
        self.updateListOnServer()
        
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController!.popViewController(animated: true)
        
    }
    
    @IBAction func addNewContact(_ sender: UIButton)
    {
//        self.listData.contactList.removeAll()
//        self.listData.contactList = self.searchData
        
        
        
            let createListVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateListVC") as! CreateListVC
            createListVC.listData = self.listData
            createListVC.isUpdated = true
            
            
            self.present(createListVC, animated: true, completion: nil)
            

        
    }
    
    
    func updateListOnServer()
    {
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String : Any]()
        postParams["contact_list"] = self.convertSelectedDataintoJson()
        postParams["list_id"] = self.listData.id
        postParams["list_name"] = self.listData.name
        
        ServerManager.updateList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let msg = json["messages"] as? String
            
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
                self.contactListTableView.reloadData()
//                BasicFunctions.showAlert(vc: self, msg: msg)
            }
            else
            {
                if msg != nil
                {
                    BasicFunctions.showAlert(vc: self, msg: msg)
                }
            }
            
        }
        
    }
    func convertSelectedDataintoJson() -> String
    {
        
        var jsonFormSelectedContactList = [[String : Any]]()
        
        for contact in self.listData.contactList
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
