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
    
    @IBOutlet var countDownLabel: UILabel!
    
    @IBOutlet var secondsRemainingLabel: UILabel!
    
    var isForgotPassword : Bool!
    
    var userCredentials : UserProfileData!
    
    var timer : Timer!
    
    var count = 60
    
    
    
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
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func sendAgainButtonTapped(_ sender: UIButton)
    {
        sender.isEnabled = false
        sender.alpha = 0.5
        
        self.secondsRemainingLabel.isHidden = false
        self.countDownLabel.isHidden = false
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        self.sendSMSFromServer()
        
        
        
    }
    @objc func update()
    {
//        if self.sendAgainButton.isEnabled == false
//        {
//            self.sendAgainButton.isEnabled = true
//            self.sendAgainButton.alpha = 1.0
//        }
        
        if self.count == 0
        {
            self.sendAgainButton.isEnabled = true
            self.sendAgainButton.alpha = 1.0
            
            self.secondsRemainingLabel.isHidden = true
            self.countDownLabel.isHidden = true
            
            self.count = 60
            
            self.countDownLabel.text = String(count)
            
            self.timer.invalidate()
            
        }
        else
        {
            self.countDownLabel.text = String(count)
            count -= 1
            
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
            
    
            if self.isForgotPassword == true
            {
                ServerManager.verifyForgetPasswordCode(postParams, withBaseURL : kBaseURL) { (result) in
                    
                    BasicFunctions.stopActivityIndicator(vu: self.view)
                    self.handleServerResponseofVerification(result as! [String : Any])
                }
                
            }
            else
            {
                ServerManager.verifySMSCode(postParams, withBaseURL : kBaseURL) { (result) in
                    
                    BasicFunctions.stopActivityIndicator(vu: self.view)
                    self.handleServerResponseofVerification(result as! [String : Any])
                }
                
            }
    
        }
        func handleServerResponseofVerification(_ json: [String: Any])
        {
    
            self.resetAllTextFields()
            
            let status = json["status"] as? String
            let message = json["message"] as? String
    
            if  json["error"] == nil && status == "success"
            {
                if self.isForgotPassword == true
                {
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                    let updatePasswordVC : UpdatePasswordVC = storyBoard.instantiateViewController(withIdentifier: "UpdatePasswordVC") as! UpdatePasswordVC
                    updatePasswordVC.userProfileData = self.userCredentials
                    
                    BasicFunctions.pushVCinNCwithObject(vc: updatePasswordVC, popTop: false)
                    
                }
                else
                {
                    if self.userCredentials.isFBSignUp
                    {
                        self.registerWithSocialAccount()
                    }
                    else
                    {
                        self.register()
                    }

                }
                
    
            }
            else if status == "error"
            {
                
                BasicFunctions.showAlert(vc: self, msg: json["Error"] as? String)
            }
            else
            {
              BasicFunctions.showAlert(vc: self, msg: message)
            }
    
            
    
    
        }
    
    func register()
    {
        
        
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["firstName"] = self.userCredentials.firstName
        postParams["lastName"] = self.userCredentials.lastName
        postParams["gender"] = self.userCredentials.gender
        postParams["phone"] = self.userCredentials.phone
        postParams["dob"] = self.userCredentials.dob
        postParams["email"] = self.userCredentials.email
        postParams["password"] = self.userCredentials.password
        postParams["password_confirmation"] = self.userCredentials.password
        
        
        ServerManager.signUp(postParams, withBaseURL : kBaseURL) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any])
        }
        
    }
    func registerWithSocialAccount()
    {
    
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["firstName"] = self.userCredentials.firstName
        postParams["lastName"] = self.userCredentials.lastName
        postParams["gender"] = self.userCredentials.gender
        postParams["phone"] = self.userCredentials.phone
        postParams["dob"] = self.userCredentials.dob
        postParams["email"] = self.userCredentials.email
        postParams["facebook_id"] = self.userCredentials.password
        postParams["password"] = self.userCredentials.password
        postParams["password_confirmation"] = self.userCredentials.password
        
        
        ServerManager.socialSignUp(postParams, withBaseURL : kBaseURL) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any])
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
        
        ServerManager.sign(in: postParams, withBaseURL : kBaseURL) { (result) in
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
                self.login()
                return
            }
            
            let userID = json["user_id"] as? Int
            let authToken = (json["access_token"] as? String)!
            
            
            BasicFunctions.setPreferences(authToken, key: kAccessToken)
            BasicFunctions.setPreferences(userID, key: kUserID)
            
            
            //            let userProfile = UserProfile.init(id: userProfileData.authID, accessToken: userProfileData.authToken)
            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userProfile)
            //            BasicFunctions.setPreferences(encodedData, key: kUserProfile)
            
            
            
            self.updateDeviceToken()
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
//                errorString = "Something went wrong with registration and login"
//            }
            
            BasicFunctions.showAlert(vc: self, msg: errorString)
        }
        
    }
    func updateDeviceToken()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["device_token"] = BasicFunctions.getPreferences(kDeviceToken)
        postParams["platform"] = "ios"
        
        var environmentString : String!
        #if DEVELOPMENT
        environmentString = "development"
        #else
        environmentString = "production"
        #endif
        
        postParams["environment"] = environmentString
        
        ServerManager.updateDeviceToken(postParams, withBaseURL : kBaseURL,accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String : Any]
            
            let status = json?["status"] as? String
            //            let message = json?["message"] as? String
            
            //            if message != nil && message == "Unauthorized"
            //            {
            //                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            //                BasicFunctions.showSigInVC()
            //                return
            //
            //            }
            
            if status != nil
            {
                
            }
            
            kUserList.removeAll()
            BasicFunctions.setUserLoggedIn()
            BasicFunctions.setHomeVC()
            BasicFunctions.fetchAllContactsFromDevice()
            
            
        }
        
    }
    func resetAllTextFields()
    {
        self.textField1.text = ""
        self.textField2.text = ""
        self.textField3.text = ""
        self.textField4.text = ""
        
        self.textField1.becomeFirstResponder()
    }
    func sendSMSFromServer()
    {
       self.resetAllTextFields()
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["phone"] = self.userCredentials.phone
        
        if self.isForgotPassword == true
        {
            ServerManager.sendSMS(withForgetPassword: postParams, withBaseURL : kBaseURL) { (result) in
                
                
                BasicFunctions.stopActivityIndicator(vu: self.view)
                self.handleServerResponseOfSendSMS(result as! [String : Any])
            }
            
        }
        else
        {
            ServerManager.sendSMS(postParams, withBaseURL : kBaseURL) { (result) in
                
                BasicFunctions.stopActivityIndicator(vu: self.view)
                self.handleServerResponseOfSendSMS(result as! [String : Any])
            }
            
        }
        
        
        
    }
    func handleServerResponseOfSendSMS(_ json: [String: Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if  json["error"] == nil && status == "success"
        {
            
            
            
        }
        else
        {
            BasicFunctions.showAlert(vc: self, msg: message)
            
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
