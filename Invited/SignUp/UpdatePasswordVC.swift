//
//  UpdatePasswordVC.swift
//  Invited
//
//  Created by ShayanSolutions on 7/24/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class UpdatePasswordVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    var userProfileData : UserProfileData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton)
    {
        if (self.passwordTextField.text?.isEmpty)!
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
            BasicFunctions.showAlert(vc: self, msg: "The password confirmation does not match.")
            return
            
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String: Any]()
        postParams["phone"] = self.userProfileData.phone
        postParams["password"] = self.passwordTextField.text
        postParams["password_confirmation"] = self.confirmPasswordTextField.text
        
        
        
        ServerManager.updatePassword(postParams) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfUpdatePassword(result as! [String : Any])

        }
        
        
        
    }
    func handleServerResponseOfUpdatePassword(_ json: [String: Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if  json["error"] == nil && status == "success"
        {
            self.navigationController?.popToRootViewController(animated: true)
            BasicFunctions.showAlert(vc: self, msg: message)
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
            else if json["password_confirmation"] != nil
            {
                errorString = (json["password_confirmattion"] as! Array)[0]
            }
            
            BasicFunctions.showAlert(vc: self, msg: errorString)
        }
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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
