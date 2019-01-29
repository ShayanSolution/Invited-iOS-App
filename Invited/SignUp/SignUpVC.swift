//
//  SignUpVC.swift
//  Invited
//
//  Created by ShayanSolutions on 5/21/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import NKVPhonePicker
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import TwitterKit


class UserProfileData: NSObject
{
    var authID = Int()
    var authToken = String()
    var firstName = String()
    var lastName = String()
    var gender = Int()
    var phone = String()
    var dob = String()
    var dor = String()
    var email = String()
    var imageURL = String()
    var password = String()
    var createdAt = String()
    var updatedAt = String()
    var isFBSignUp = Bool()
    
}

class SignUpVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
   
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    

    
    

    @IBOutlet var signInScrollView: UIScrollView!



    
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var phoneTextField: NKVPhonePickerTextField!
    
    @IBOutlet var dobTextField: UITextField!
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
    
    let genderList = ["Select Gender","Male","Female"]
    
    let datePicker = UIDatePicker()
    
    let dropDownPickerView = UIPickerView()
    
    let userProfileData = UserProfileData()
    
    let dateformatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
//        self.findBaseURL()
        
        let currentDate = Date()
        
        
        let dateString = String(format: "1990-%@-%@", currentDate.month,currentDate.day)
        
        self.dateformatter.dateFormat = "yyyy-MM-dd"
        
        let date = self.dateformatter.date(from: dateString)
        
        if date != nil
        {
            self.datePicker.date = date!
        }
        
        self.showPicker(textField: self.genderTextField)
        self.showDatePicker(textField: self.dobTextField)
        
//        self.contraintContentHeight.constant = 700.0
        
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
            
            self.signInScrollView.isHidden = false
            self.mainScrollView.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

        self.mainScrollView.contentSize.height = 600.0
        self.signInScrollView.contentSize.height = 250.0
        
//        self.showPicker(textField: self.genderTextField)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//    func findBaseURL()
//    {
//        if kBaseURL.isEmpty
//        {
//            ServerManager.getURL(nil, withBaseURL: kConfigURL) { (result) in
//                let urlDictionary = result as? [String : Any]
//                kBaseURL = urlDictionary?["URL"] as? String ?? "http://dev.invited.shayansolutions.com/"
//            }
//        }
//    }
    
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton)
    {
        self.signUpButton.backgroundColor = UIColor.init(red: 255/255, green: 92/255, blue: 76/255, alpha: 1.0)
        self.signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.signInButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        BasicFunctions.setborderOfButton(button: self.signInButton, color: UIColor.red)
        
        
        self.signInScrollView.isHidden = true
        self.mainScrollView.isHidden = false
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton)
    {
        self.signInButton.backgroundColor = UIColor.init(red: 255/255, green: 92/255, blue: 76/255, alpha: 1.0)
        self.signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.signUpButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        BasicFunctions.setborderOfButton(button: self.signUpButton, color: UIColor.red)
        
        self.signInScrollView.isHidden = false
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
        
        
        
        
        ServerManager.sendSMS(withForgetPassword: postParams, withBaseURL : kBaseURL) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfSendSMS(result as! [String : Any], isForget: true)
            
        }
    }
    
    
    @IBAction func signUpFB(_ sender: UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        let loginManager = LoginManager()
        loginManager.logOut()

        loginManager.logIn(readPermissions: [.publicProfile,.email,.userBirthday], viewController: self) { (loginResult) in

            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                
                if sender.tag == 1
                {
                    self.getFBUserData(isFBLogin: false)
                }
                else
                {
                    self.getFBUserData(isFBLogin: true)
                }
                
            }
        }
    }
    
    func getFBUserData(isFBLogin : Bool)
    {
        if((FBSDKAccessToken.current()) != nil)
        {

            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,email,birthday"]).start(completionHandler: { (connection, result, error) -> Void in

                if (error == nil){
                    
                    let userInfo = result as? [String:Any]
                    self.userProfileData.firstName = userInfo?["first_name"] as? String ?? ""
                    self.userProfileData.lastName = userInfo?["last_name"] as? String ?? ""
                    self.userProfileData.gender = 1
                    let dobString = userInfo?["birthday"] as? String ?? ""
                    self.userProfileData.email = userInfo?["email"] as? String ?? ""
                    self.userProfileData.password = userInfo?["id"] as? String ?? "123456"
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    
                    let date = formatter.date(from: dobString)
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    if date != nil
                    {
                        self.userProfileData.dob = formatter.string(from: date!)
                    }
                    
                    
                    if isFBLogin
                    {
                        self.userProfileData.isFBSignUp = false
                        self.login(isLoginManually: false)
                    }
                    else
                    {
                        self.userProfileData.isFBSignUp = true
                        self.goToPhoneVC()
                    }
                    
                }
            })
        }
    }
    
    @IBAction func loginTwitter(_ sender: UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                //                print("username \(session?.userName)")
                //                print("token \(session?.authToken)")
                //                print("tokensecret \(session?.authTokenSecret)")
                //                print("userid \(session?.userID)")
                
                BasicFunctions.stopActivityIndicator(vu: self.view)
                
                self.userProfileData.firstName = "H"
                self.userProfileData.lastName = "K"
                self.userProfileData.gender = 1
                self.userProfileData.dob = "11/08/2018"
                self.userProfileData.email = ""
                self.userProfileData.password = "123456"
                
                self.goToPhoneVC()
                
                
            } else {
                BasicFunctions.stopActivityIndicator(vu: self.view)
                BasicFunctions.showAlert(vc: self, msg: error?.localizedDescription)
            }
        })
    }
    
    
    func goToPhoneVC()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let phoneVC : PhoneVC = storyBoard.instantiateViewController(withIdentifier: "PhoneVC") as! PhoneVC
        phoneVC.userCredentials = self.userProfileData
        
        
        BasicFunctions.pushVCinNCwithObject(vc: phoneVC, popTop: false)
    }
    
    
    
    
    @IBAction func register(_ sender: UIButton)
    {

        if (self.firstNameTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put first name.")
            return
        }
        else if (self.lastNameTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put last name.")
            return
        }
        else if (self.phoneTextField.code?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select country.")
            return
        }
        else if self.phoneTextField.phoneNumber == self.phoneTextField.code
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put phone number.")
            return

        }
        else if (self.passwordTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put password.")
            return
        }
        else if (self.passwordTextField.text?.count)! < 6
        {
            BasicFunctions.showAlert(vc: self, msg: "Password must be at least 6 characters.")
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
        
        
        self.dateformatter.dateFormat = "yyyy-MM-dd"

        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["firstName"] = self.firstNameTextField.text
        postParams["lastName"] = self.lastNameTextField.text
        postParams["phone"] = self.phoneTextField.text
        postParams["email"] = self.emailTextField.text
        postParams["password"] = self.passwordTextField.text
        postParams["password_confirmation"] = self.confirmPasswordTextField.text
        
        var dobDate : String!
        if (self.dobTextField.text?.isEmpty)!
        {
            dobDate = ""
        }
        else
        {
            dobDate = dateformatter.string(from: self.datePicker.date)
        }
        
        postParams["dob"] = dobDate
        
        var gender : Int!
        
        if self.genderTextField.text == "Male"
        {
            gender = 1
        }
        else if self.genderTextField.text == "Female"
        {
            gender = 2
        }
        else
        {
            gender = 0
        }
        
        postParams["gender"] = gender


        ServerManager.validation(postParams, withBaseURL : kBaseURL) { (result) in

            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any], isLoginManually : false)
        }
        
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton)
    {
        self.login(isLoginManually: true)
    }
    
    func login(isLoginManually : Bool)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String: Any]()
        
        if isLoginManually
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
            
            postParams["username"] = self.loginPhoneTextField.text
            postParams["password"] = self.loginPasswordTextField.text
            
        }
        else
        {
            postParams["username"] = self.userProfileData.password
            postParams["password"] = self.userProfileData.password
        }
        
    
        postParams["client_id"] = "1"
        postParams["client_secret"] = "mA696UDP5ibROH9aeqAOSJGGsZIiVHR0KqXYZRzh"
        postParams["grant_type"] = "password"
        postParams["scope"] = "*"
        postParams["role"] = "user"
        
        ServerManager.sign(in: postParams, withBaseURL : kBaseURL) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any], isLoginManually : isLoginManually)
        }
    }
    func resetData()
    {
        self.phoneTextField.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.confirmPasswordTextField.text = ""
    }
    
    func handleServerResponse(_ json: [String: Any], isLoginManually : Bool)
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
                
                if isLoginManually == false && self.userProfileData.isFBSignUp == false
                {
                    self.userProfileData.isFBSignUp = true
                    self.goToPhoneVC()
                    return
                }
            }
//            else
//            {
//                errorString = "Something went wrong with validation and login"
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
        
        ServerManager.updateDeviceToken(postParams, withBaseURL : kBaseURL, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
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
                kUserList.removeAll()
                BasicFunctions.setUserLoggedIn()
                BasicFunctions.setHomeVC()
                BasicFunctions.fetchAllContactsFromDevice()
            }
            
            
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
        
        ServerManager.sendSMS(postParams, withBaseURL : kBaseURL) { (result) in
            
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
            
            
            if isForget == true
            {
                self.userProfileData.phone = self.loginPhoneTextField.text!
            
            }
            else
            {
                self.dateformatter.dateFormat = "yyyy-MM-dd"
                
                self.userProfileData.firstName = self.firstNameTextField.text!
                self.userProfileData.lastName = self.lastNameTextField.text!
                self.userProfileData.phone = self.phoneTextField.text!
                self.userProfileData.email = self.emailTextField.text!
                self.userProfileData.password = self.passwordTextField.text!
                
                var dobDate : String!
                if (self.dobTextField.text?.isEmpty)!
                {
                    dobDate = ""
                }
                else
                {
                    dobDate = dateformatter.string(from: self.datePicker.date)
                }
                
                self.userProfileData.dob = dobDate
                
                var gender : Int!
                
                if self.genderTextField.text == "Male"
                {
                    gender = 1
                }
                else if self.genderTextField.text == "Female"
                {
                    gender = 2
                }
                else
                {
                    gender = 0
                }
                
                self.userProfileData.gender = gender
                
            }
            
            verifyCodeVC.userCredentials = userProfileData
            verifyCodeVC.isForgotPassword = isForget
            
            
            
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.genderList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0
        {
            self.genderTextField.text = ""
        }
        else
        {
            self.genderTextField.text = self.genderList[row]
        }
    }
    func showPicker(textField:UITextField!)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.dropDownPickerView.dataSource = self
        self.dropDownPickerView.delegate = self


//        self.dropDownPickerView.tag = textField.tag



        textField.inputView = self.dropDownPickerView
        textField.inputAccessoryView = toolBar

    }

    func showDatePicker(textField:UITextField!){
        
        //Formate Date
        self.datePicker.datePickerMode = .date
        
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
        // add datepicker to textField
        textField.inputView = self.datePicker
        
    }
    
    @objc func donedatePicker(sender : UIBarButtonItem){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        self.dobTextField.text = formatter.string(from: self.datePicker.date)
        
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        
        self.view.endEditing(true)
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
