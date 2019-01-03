//
//  ProfileVC.swift
//  Invited
//
//  Created by ShayanSolutions on 12/26/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var profileScrollView: UIScrollView!
    
    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var dobTextField: UITextField!
    
    @IBOutlet var dorTextField: UITextField!
    
    
    let dobPicker = UIDatePicker()
    let dorPicker = UIDatePicker()
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.profileScrollView.contentSize.height = 485.0
        
        self.showDatePicker(textField: self.dobTextField)
        self.showDatePicker(textField: self.dorTextField)
        
        self.getProfileFromServer()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.openLeftMenu(vc: self)
    }
    
    func getProfileFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        ServerManager.getUserProfile(nil, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfGetProfile(json: result as? [String : Any])
            
        }
    }
    func handleServerResponseOfGetProfile(json : [String : Any]?)
    {
        let message = json?["message"] as? String
        let userData = json?["user"] as? [String : Any]
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if json?["error"] == nil && userData != nil
        {
            self.firstNameTextField.text = userData?["firstName"] as? String ?? ""
            self.lastNameTextField.text = userData?["lastName"] as? String ?? ""
            self.emailTextField.text = userData?["email"] as? String ?? ""
            let dobString = userData?["dob"] as? String ?? ""
            let dorString = userData?["dateofrelation"] as? String ?? ""
            
            self.dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = self.dateFormatter.date(from: dobString)
            let dorDate = self.dateFormatter.date(from: dorString)
            
            self.dateFormatter.dateFormat = "dd/MM/yyyy"
            
            if dobDate != nil
            {
                self.dobTextField.text = self.dateFormatter.string(from: dobDate!)
            }
            
            if dorDate != nil
            {
                self.dorTextField.text = self.dateFormatter.string(from: dorDate!)
            }
            
            
            
            
            
        }
        else if message != nil
        {
            BasicFunctions.showAlert(vc: self, msg: message!)
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton)
    {
        if self.firstNameTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put first name.")
            return
        }
        else if self.lastNameTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put last name.")
            return
        }
        else if self.emailTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put email.")
            return
        }
        else if self.dobTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put date of birth.")
            return
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var postParams = [String : Any]()
        postParams["user_id"] = BasicFunctions.getPreferencesForInt(kUserID)
        postParams["firstName"] = self.firstNameTextField.text
        postParams["lastName"] = self.lastNameTextField.text
        postParams["email"] = self.emailTextField.text
        postParams["dob"] = self.dateFormatter.string(from: self.dobPicker.date)
        postParams["dateofrelation"] = self.dateFormatter.string(from: self.dorPicker.date)
        
        ServerManager.updateUserProfile(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfUpdateProfile(json: result as? [String : Any])
            
        }
        
    }
    
    func handleServerResponseOfUpdateProfile(json : [String : Any]?)
    {
        
//        let status = json?["status"] as? String
        let message = json?["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        BasicFunctions.showAlert(vc: self, msg: message)
        self.view.endEditing(true)
        
//        if json?["error"] == nil && status != nil
//        {
//            BasicFunctions.showAlert(vc: self, msg: message)
//        }
//        else
//        {
//            BasicFunctions.showAlert(vc: self, msg: message)
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func showDatePicker(textField:UITextField!){
        
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donedatePicker(sender:)))
        doneButton.tag = textField.tag
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        
        
        if textField.tag == 1
        {
            //Formate Date
            self.dobPicker.datePickerMode = .date
            
            // add datepicker to textField
            textField.inputView = self.dobPicker
        }
        else
        {
            //Formate Date
            self.dorPicker.datePickerMode = .date
            
            // add datepicker to textField
            textField.inputView = self.dorPicker
        }
        
    }
    
    @objc func donedatePicker(sender : UIBarButtonItem){
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if sender.tag == 1
        {
            self.dobTextField.text = self.dateFormatter.string(from: self.dobPicker.date)
        }
        else
        {
            self.dorTextField.text = self.dateFormatter.string(from: self.dorPicker.date)
        }
        
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        
        self.view.endEditing(true)
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
