//
//  SignUpVC.swift
//  Invited
//
//  Created by ShayanSolutions on 5/21/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import NKVPhonePicker


class UserProfileData: NSObject
{
    var authID = Int()
    var authToken = String()
    var phone = String()
    var email = String()
    var password = String()
    
}

class SignUpVC: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var signUpView: UIView!
    
    @IBOutlet var signInView: UIView!
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet var phoneTextField: NKVPhonePickerTextField!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var loginPhoneTextField: NKVPhonePickerTextField!
    
    @IBOutlet var loginPasswordTextField: UITextField!
    
    
    
    
    @IBOutlet var contraintContentHeight: NSLayoutConstraint!
    
    var keyboardHeight : CGFloat!
    
    var activeField : UIView!
    
    var lastOffset : CGPoint!
    
    
    var isLoginPage : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.mainScrollView.contentSize.height = self.mainScrollView.frame.size.height
        
        self.addDoneButtonOnKeyboard(textField: self.loginPhoneTextField)
        self.addDoneButtonOnKeyboard(textField: self.phoneTextField)
        
        if self.isLoginPage == false
        {
            self.signUpButton.backgroundColor = UIColor.init(red: 255/255, green: 92/255, blue: 76/255, alpha: 1.0)
            
            BasicFunctions.setborderOfButton(button: self.signInButton, color: UIColor.red)
            
        }
        else
        {
            self.signInButton.backgroundColor = UIColor.init(red: 255/255, green: 92/255, blue: 76/255, alpha: 1.0)
            BasicFunctions.setborderOfButton(button: self.signUpButton, color: UIColor.red)
            
            self.signInView.isHidden = false
            self.mainScrollView.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton)
    {
        self.signUpButton.backgroundColor = UIColor.init(red: 255/255, green: 92/255, blue: 76/255, alpha: 1.0)
        self.signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.signInButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        BasicFunctions.setborderOfButton(button: self.signInButton, color: UIColor.red)
        
        
        self.signInView.isHidden = true
        self.mainScrollView.isHidden = false
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton)
    {
        self.signInButton.backgroundColor = UIColor.init(red: 255/255, green: 92/255, blue: 76/255, alpha: 1.0)
        self.signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.signUpButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        BasicFunctions.setborderOfButton(button: self.signUpButton, color: UIColor.red)
        
        self.signInView.isHidden = false
        self.mainScrollView.isHidden = true
    }
    
    @IBAction func forgetPassword(_ sender: UIButton)
    {
        if (self.loginPhoneTextField.code?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select country.")
            return
        }
        else if self.loginPhoneTextField.phoneNumber == self.loginPhoneTextField.code
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put phone number.")
            return
            
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["phone"] = self.loginPhoneTextField.text
        
        
        
        
        ServerManager.sendSMS(withForgetPassword: postParams) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfSendSMS(result as! [String : Any], isForget: true)
            
        }
    }
    
    
    
    
    @IBAction func register(_ sender: UIButton)
    {

        if (self.phoneTextField.code?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select country.")
            return
        }
        else if self.phoneTextField.phoneNumber == self.phoneTextField.code
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put phone number.")
            return
            
        }
        else if (self.emailTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put email.")
            return
        }
        else if (self.passwordTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put password.")
            return
        }
        else if (self.confirmPasswordTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please confirm password.")
            return
        }
        else if self.passwordTextField.text != self.confirmPasswordTextField.text
        {
            BasicFunctions.showAlert(vc: self, msg: "Password confirmation does not match.")
            return
        }

        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["email"] = self.emailTextField.text
        postParams["phone"] = self.phoneTextField.text
        postParams["password"] = self.passwordTextField.text
        postParams["password_confirmation"] = self.confirmPasswordTextField.text
        


        ServerManager.validation(postParams) { (result) in

            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any])
        }
        
    }
    
    @IBAction func login(_ sender: UIButton)
    {
        if (self.loginPhoneTextField.code?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select country.")
            return
        }
        else if self.loginPhoneTextField.phoneNumber == self.loginPhoneTextField.code
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put phone number.")
            return
            
        }
        else if (self.loginPasswordTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put password.")
            return
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["username"] = self.loginPhoneTextField.text
        postParams["password"] = self.loginPasswordTextField.text
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
    func resetData()
    {
        self.phoneTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.confirmPasswordTextField.text = ""
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
            
            
            let userProfileData = UserProfileData()
            let userID = json["user_id"] as? Int
            userProfileData.authID = userID!
            userProfileData.authToken = (json["access_token"] as? String)!
            
            BasicFunctions.setPreferences(userProfileData.authToken, key: kAccessToken)
            BasicFunctions.setPreferences(userProfileData.authID, key: kUserID)
            
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
                errorString = json["message"] as! String
            }
//            else
//            {
//                errorString = "Something went wrong with validation and login"
//            }
            
            BasicFunctions.showAlert(vc: self, msg: errorString)
        }
        
    }
//    func handleServerResponseOfLogin(_ json: [String: Any])
//    {
//
//        if  json["error"] == nil && json["phone"] == nil && json["email"] == nil && json["password"] == nil && json["password_confirmation"] == nil
//        {
//            if json["status"] != nil
//            {
//                self.resetData()
//                BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
//                return
//            }
//
//
//            let userProfileData = UserProfileData()
//            let userID = json["user_id"] as? Int
//            userProfileData.authID = userID!
//            userProfileData.authToken = (json["access_token"] as? String)!
//
//            BasicFunctions.setPreferences(userProfileData.authToken, key: kAccessToken)
//            BasicFunctions.setPreferences(userProfileData.authID, key: kUserID)
//
//
//
//            //            let userProfile = UserProfile.init(id: userProfileData.authID, accessToken: userProfileData.authToken)
//            //            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userProfile)
//            //            BasicFunctions.setPreferences(encodedData, key: kUserProfile)
//
////            self.sendSMSFromServer()
//
//            //            BasicFunctions.setUserLoggedIn()
//            //            BasicFunctions.setHomeVC()
//        }
//        else
//        {
//            var errorString : String!
//
//            if  json["phone"] != nil
//            {
//                errorString = (json["phone"] as! Array)[0]
//            }
//            else if json["email"] != nil
//            {
//                errorString = (json["email"] as! Array)[0]
//            }
//            else if json["message"] != nil
//            {
//                errorString = json["message"] as! String
//            }
//            else if json["password"] != nil
//            {
//                errorString = (json["password"] as! Array)[0]
//            }
//            else if json["password_confirmation"] != nil
//            {
//                errorString = (json["password_confirmattion"] as! Array)[0]
//            }
//            else
//            {
//                errorString = "Could not communicate with the server."
//            }
//
//            BasicFunctions.showAlert(vc: self, msg: errorString)
//        }
//
//    }
    func sendSMSFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["phone"] = self.phoneTextField.text
        
        ServerManager.sendSMS(postParams) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfSendSMS(result as! [String : Any], isForget: false)
        }
        
    }
    func handleServerResponseOfSendSMS(_ json: [String: Any], isForget : Bool)
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if  json["error"] == nil && status == "success"
        {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let verifyCodeVC : VerifyCodeVC = storyBoard.instantiateViewController(withIdentifier: "VerifyCodeVC") as! VerifyCodeVC
            
            let userProfileData = UserProfileData()
            
            if isForget == true
            {
                userProfileData.phone = self.loginPhoneTextField.text!
            
            }
            else
            {
                userProfileData.phone = self.phoneTextField.text!
                userProfileData.email = self.emailTextField.text!
                userProfileData.password = self.passwordTextField.text!
                
            }
            
            verifyCodeVC.userCredentials = userProfileData
            verifyCodeVC.isForgetPassword = isForget
            
            
            
            BasicFunctions.pushVCinNCwithObject(vc: verifyCodeVC, popTop: false)

            
        }
        else
        {
            BasicFunctions.showAlert(vc: self, msg: message)
            
        }
        
        
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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField.superview
        lastOffset = self.mainScrollView.contentOffset
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeField = nil
        return true
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.keyboardHeight != nil {
            return
        }
        if self.activeField == nil
        {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.contraintContentHeight.constant += self.keyboardHeight
            })
            // move if keyboard hide input field
            
            
            let distanceToBottom = self.mainScrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace < 0 {
                // no collapse
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.mainScrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace)
            })
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            if self.keyboardHeight != nil
            {
            self.contraintContentHeight.constant -= self.keyboardHeight
            }
            
            if self.lastOffset != nil
            {
            self.mainScrollView.contentOffset = self.lastOffset
            }
            
        }
        self.keyboardHeight = nil
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
