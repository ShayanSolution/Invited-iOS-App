//
//  VerifyCodeVC.swift
//  Invited
//
//  Created by ShayanSolutions on 6/29/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class VerifyCodeVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet var view1: UIView!
    
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view3: UIView!
    
    @IBOutlet var view4: UIView!
    
    @IBOutlet var textField1: UITextField!
    
    @IBOutlet var textField2: UITextField!
    
    @IBOutlet var textField3: UITextField!
    
    @IBOutlet var textField4: UITextField!
    
    @IBOutlet var sendAgainButton: UIButton!
    
    var userCredentials : UserProfileData!
    
    var timer : Timer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(true)
        
       self.textField1.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews()
    {
        BasicFunctions.setRoundCornerOfButton(button: self.sendAgainButton, radius: 2.0)
        
        BasicFunctions.setBorderOfView(view: self.view1)
        BasicFunctions.setBorderOfView(view: self.view2)
        BasicFunctions.setBorderOfView(view: self.view3)
        BasicFunctions.setBorderOfView(view: self.view4)
        
        
        BasicFunctions.setLeftPaddingOfTextField(textField: self.textField1, padding: 24)
        BasicFunctions.setLeftPaddingOfTextField(textField: self.textField2, padding: 24)
        BasicFunctions.setLeftPaddingOfTextField(textField: self.textField3, padding: 24)
        BasicFunctions.setLeftPaddingOfTextField(textField: self.textField4, padding: 24)
        
    }
    
    @IBAction func sendAgainButtonTapped(_ sender: UIButton)
    {
        sender.isEnabled = false
        sender.alpha = 0.5
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.sendAgainButtonEnabled), userInfo: nil, repeats: false)
        
        self.sendSMSFromServer()
        
        
        
    }
    @objc func sendAgainButtonEnabled()
    {
        if self.sendAgainButton.isEnabled == false
        {
            self.sendAgainButton.isEnabled = true
            self.sendAgainButton.alpha = 1.0
        }
        
    }
    
    // Delegate methods of Text Fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.text!.count < 1  && string.count > 0{
            let nextTag = textField.tag + 1
            
            // get next responder
            let nextResponder = textField.superview?.superview?.viewWithTag(nextTag)
            
            if (nextResponder == nil){
                textField.text = string
                self.checkPhoneCode()
                
            }
            textField.text = string
            nextResponder?.becomeFirstResponder()
            return false
        }
        else if textField.text!.count >= 1  && string.count == 0{
            // on deleting value from Textfield
            let previousTag = textField.tag - 1
            
            // get next responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            
            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false
        }
        return true
    }
    
        func checkPhoneCode()
        {
            BasicFunctions.showActivityIndicator(vu: self.view)
    
            var postParams = [String: Any]()
            postParams["phone"] = self.userCredentials.phone
    
            postParams["code"] = Int(self.textField1.text! + self.textField2.text! + self.textField3.text! + self.textField4.text!)
            
    
            ServerManager.verifySMSCode(postParams) { (result) in
            
                BasicFunctions.stopActivityIndicator(vu: self.view)
                self.handleServerResponseofVerification(result as! [String : Any])
            }
    
        }
        func handleServerResponseofVerification(_ json: [String: Any])
        {
    
    
            if  json["error"] == nil && json["Error"] == nil
            {
                self.login()
                
    
            }
            else
            {
                BasicFunctions.showAlert(vc: self, msg: json["Error"] as! String)
            }
    
    
    
        }
    func login()
    {
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["username"] = self.userCredentials.phone
        postParams["password"] = self.userCredentials.password
        postParams["client_id"] = "1"
        postParams["client_secret"] = "mA696UDP5ibROH9aeqAOSJGGsZIiVHR0KqXYZRzh"
        postParams["grant_type"] = "password"
        postParams["scope"] = "*"
        postParams["role"] = "user"
        
        ServerManager.sign(in: postParams) { (result) in
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any])
        }
        
    }
    func handleServerResponse(_ json: [String: Any])
    {
        
        if  json["error"] == nil && json["phone"] == nil && json["password"] == nil
        {
//            if json["status"] != nil
//            {
//                //                self.resetData()
//                //                BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
//
//                return
//            }
            
            
            let userProfileData = UserProfileData()
            let userID = json["user_id"] as? Int
            userProfileData.authID = userID!
            userProfileData.authToken = (json["access_token"] as? String)!
            
            BasicFunctions.setPreferences(userProfileData.authToken, key: kAccessToken)
            BasicFunctions.setPreferences(userProfileData.authID, key: kUserID)
            
            
            
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
            else if json["password"] != nil
            {
                errorString = (json["password"] as! Array)[0]
            }
            else
            {
                errorString = "Could not communicate with the server."
            }
            
            BasicFunctions.showAlert(vc: self, msg: errorString)
        }
        
    }
    func sendSMSFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["phone"] = self.userCredentials.phone
        
        ServerManager.sendSMS(postParams) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfSendSMS(result as! [String : Any])
        }
        
    }
    func handleServerResponseOfSendSMS(_ json: [String: Any])
    {
        if  json["error"] == nil && json["Error"] == nil
        {
            

        }
        else
        {
            var errorString : String!
            
            if  json["Error"] != nil
            {
                errorString = json["Error"] as! String
            }
            else
            {
                errorString = "Could not communicate with the server."
            }
            
            BasicFunctions.showAlert(vc: self, msg: errorString)
            
        }
        
        
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
