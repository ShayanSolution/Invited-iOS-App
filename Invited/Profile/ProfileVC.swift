//
//  ProfileVC.swift
//  Invited
//
//  Created by ShayanSolutions on 12/26/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}

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
    
    let currentDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
        
        self.profileScrollView.contentSize.height = 485.0
        
        
        self.firstNameTextField.text = kLoggedInUserProfile.firstName
        self.lastNameTextField.text = kLoggedInUserProfile.lastName
        self.emailTextField.text = kLoggedInUserProfile.email
        self.dobTextField.text = kLoggedInUserProfile.dob
        self.dorTextField.text = kLoggedInUserProfile.dor
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        var updatedDate : Date!

        if kLoggedInUserProfile.updatedAt != ""
        {
            updatedDate = self.dateFormatter.date(from: kLoggedInUserProfile.updatedAt!)
        }
        else if kLoggedInUserProfile.createdAt != ""
        {
            updatedDate = self.dateFormatter.date(from: kLoggedInUserProfile.createdAt!)
        }




        var year : Int!

        if updatedDate != nil
        {
            year = BasicFunctions.compareDates(fromDate: updatedDate, toDate: currentDate)
        }

        if year < 1
        {
            if kLoggedInUserProfile.dob != ""
            {
                self.dobTextField.isUserInteractionEnabled = false
            }

            if kLoggedInUserProfile.dor != ""
            {
                self.dorTextField.isUserInteractionEnabled = false
            }
        }
        
        
        self.showDatePicker(textField: self.dobTextField)
        self.showDatePicker(textField: self.dorTextField)
        
        
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.openLeftMenu(vc: self)
    }
    
    
    
    @IBAction func updateButtonTapped(_ sender: UIButton)
    {
//        self.dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateObj = self.dateFormatter.date(from: self.dobTextField.text!)
//        
//        var dobDateString : String!
//        if dateObj != nil
//        {
//            dobDateString = self.dateFormatter.string(from: dateObj!)
//        }
//        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        let dobTimesTamp = self.dateFormatter.date(from: dobDateString)
//        
//        let year = BasicFunctions.compareDates(fromDate: currentDate, toDate: dobTimesTamp)
    
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
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var postParams = [String : Any]()
        postParams["user_id"] = BasicFunctions.getPreferencesForInt(kUserID)
        postParams["firstName"] = self.firstNameTextField.text
        postParams["lastName"] = self.lastNameTextField.text
        postParams["email"] = self.emailTextField.text
        
        var date = self.dateFormatter.date(from: self.dobTextField.text!)
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        if date != nil
        {
            postParams["dob"] = self.dateFormatter.string(from: date!)
        }
        else
        {
            postParams["dob"] = ""
        }
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        date = self.dateFormatter.date(from: self.dorTextField.text!)
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if date != nil
        {
            postParams["dateofrelation"] = self.dateFormatter.string(from: date!)
        }
        else
        {
            postParams["dateofrelation"] = ""
        }
        
        
        ServerManager.updateUserProfile(postParams, withBaseURL : kBaseURL,accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
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
        
        let dateString = String(format: "%@/%@/1990", currentDate.day,currentDate.month)
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        
        
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
            self.dobPicker.datePickerMode = .date
            
            let date = self.dateFormatter.date(from: self.dobTextField.text!)
            
            
            if date != nil
            {
                self.dobPicker.date = date!
            }
            else
            {
                //                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let date = self.dateFormatter.date(from: dateString)
                
                if date != nil
                {
                    self.dobPicker.date = date!
                }
            }
            
            
            // add datepicker to textField
            textField.inputView = self.dobPicker
        }
        else
        {
            self.dorPicker.datePickerMode = .date
            
            let date = self.dateFormatter.date(from: self.dorTextField.text!)
            
            
            if date != nil
            {
                self.dorPicker.date = date!
            }
            else
            {
                //                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let date = self.dateFormatter.date(from: dateString)
                
                if date != nil
                {
                    self.dorPicker.date = date!
                }
            }
            
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
