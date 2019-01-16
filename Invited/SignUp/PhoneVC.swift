//
//  PhoneVC.swift
//  Invited
//
//  Created by ShayanSolutions on 12/13/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import NKVPhonePicker

class PhoneVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var phoneNumberTextField: NKVPhonePickerTextField!
    
    var userCredentials : UserProfileData!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addDoneButtonOnKeyboard(textField: self.phoneNumberTextField)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendCode(_ sender: UIButton)
    {
        if (self.phoneNumberTextField.code?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select country.")
            return
        }
        else if self.phoneNumberTextField.phoneNumber == self.phoneNumberTextField.code
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put phone number.")
            return
            
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["firstName"] = self.userCredentials.firstName
        postParams["lastName"] = self.userCredentials.lastName
        postParams["phone"] = self.phoneNumberTextField.text
        postParams["dob"] = self.userCredentials.dob
        postParams["email"] = self.userCredentials.email
        postParams["password"] = self.userCredentials.password
        postParams["password_confirmation"] = self.userCredentials.password
        postParams["gender"] = 1
        
        
        ServerManager.validation(postParams, withBaseURL : kBaseURL) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any])
        }
        
        
    }
    func handleServerResponse(_ json: [String: Any])
    {
        
        if  json["error"] == nil && json["phone"] == nil && json["email"] == nil && json["password"] == nil && json["password_confirmation"] == nil
        {
            if json["status"] != nil
            {
                
                self.sendSMSFromServer()
                
                return
            }
            
            
            let userID = json["user_id"] as? Int
            let authToken = (json["access_token"] as? String)!
            
            BasicFunctions.setPreferences(authToken, key: kAccessToken)
            BasicFunctions.setPreferences(userID, key: kUserID)
            
            kUserList.removeAll()
            
            
            
            //            let userProfile = UserProfile.init(id: userProfileData.authID, accessToken: userProfileData.authToken)
            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userProfile)
            //            BasicFunctions.setPreferences(encodedData, key: kUserProfile)
            
            
            
            BasicFunctions.setUserLoggedIn()
            BasicFunctions.setHomeVC()
            BasicFunctions.fetchAllContactsFromDevice()
            
        }
        else
        {
            var errorString : String!
            
            if  json["phone"] != nil
            {
                errorString = (json["phone"] as! Array)[0]
            }
            else if json["email"] != nil
            {
                errorString = (json["email"] as! Array)[0]
            }
            else if json["password"] != nil
            {
                errorString = (json["password"] as! Array)[0]
            }
            else if json["password_confirmation"] != nil
            {
                errorString = (json["password_confirmattion"] as! Array)[0]
            }
            else if json["error"] != nil
            {
                errorString = json["message"] as? String
            }
            //            else
            //            {
            //                errorString = "Something went wrong with validation and login"
            //            }
            
            BasicFunctions.showAlert(vc: self, msg: errorString)
        }
        
    }
    
    func sendSMSFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["phone"] = self.phoneNumberTextField.text
        
        ServerManager.sendSMS(postParams, withBaseURL : kBaseURL) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfSendSMS(isForget: false)
        }
        
    }
    func handleServerResponseOfSendSMS(isForget : Bool)
    {
        //        let status = json["status"] as? String
        //        let message = json["message"] as? String
        //
        //        if  json["error"] == nil && status == "success"
        //        {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let verifyCodeVC : VerifyCodeVC = storyBoard.instantiateViewController(withIdentifier: "VerifyCodeVC") as! VerifyCodeVC
        
        self.userCredentials.phone = self.phoneNumberTextField.text
        verifyCodeVC.userCredentials = self.userCredentials
        
        BasicFunctions.pushVCinNCwithObject(vc: verifyCodeVC, popTop: false)
        
        
        //        }
        //        else
        //        {
        //            BasicFunctions.showAlert(vc: self, msg: message)
        //
        //        }
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnKeyboard(textField:UITextField!)
    {
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(self.doneClick))
        
        toolbar.setItems([spaceButton,doneButton], animated: false)
        
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneClick()
    {
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
