//
//  LeftMenuVC.swift
//  Invited
//
//  Created by ShayanSolutions on 12/18/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {
    
    @IBOutlet var versionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        
        if appVersion != nil
        {
            self.versionLabel.text = String(format: "v%@", appVersion!)
        }
    }
    
    
    
    @IBAction func homeButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.hideLeftMenu(vc: self)
        BasicFunctions.pushVCinNCwithName("HomeVC", popTop: true)
    }
    @IBAction func profileButtonTapped(_ sender: UIButton)
    {
        
        BasicFunctions.hideLeftMenu(vc: self)
        BasicFunctions.pushVCinNCwithName("ProfileVC", popTop: true)
        
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.hideLeftMenu(vc: self)
        
        let alert = UIAlertController.init(title: "Invited", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            BasicFunctions.showActivityIndicator(vu: self.view)
            
//            let store = TWTRTwitter.sharedInstance().sessionStore
//            if let userID = store.session()?.userID {
//                store.logOutUserID(userID)
//                BasicFunctions.showSigInVC()
//                return
//            }
//            else if (FBSDKAccessToken.current() != nil)
//            {
//                FBSDKLoginManager().logOut()
//                BasicFunctions.showSigInVC()
//                return
//            }
            
            
            
            ServerManager.signOut(nil,withBaseURL : kBaseURL,accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
                
                
                BasicFunctions.stopActivityIndicator(vu: self.view)
                
                
                let json = result as? [String : Any]
                
                
                if json == nil
                {
                    
                    BasicFunctions.showSigInVC()
                    
                }
                else if json!["error"] != nil
                {
                    BasicFunctions.showAlert(vc: self, msg: json!["message"] as? String)
                }
                else
                {
                    
                    
                    let message = json!["message"] as? String
                    
                    
                    if message != nil && message == "Unauthorized"
                    {
                        BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                        BasicFunctions.showSigInVC()
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
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
