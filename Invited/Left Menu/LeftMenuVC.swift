//
//  LeftMenuVC.swift
//  Invited
//
//  Created by ShayanSolutions on 12/18/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class NotificationData: NSObject
{
    var id = Int()
    var notification_id = Int()
    var event_id = Int()
    var sender_name = String()
    var related_screen = String()
    var read_status = Int()
    var message = String()
    var sender_image = String()
}

class LeftMenuVC: UIViewController {
    
    @IBOutlet var versionLabel: UILabel!
    
    @IBOutlet var notificationsCountLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        
        if appVersion != nil
        {
            self.versionLabel.text = String(format: "v%@", appVersion!)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        BasicFunctions.getNotificationsListFromServer { (notificationCount) in
        
            if notificationCount > 0
            {
                self.notificationsCountLabel.isHidden = false
                self.notificationsCountLabel.text = String(notificationCount)
            }
            else
            {
                self.notificationsCountLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        notificationsCountLabel.layer.masksToBounds = true
        notificationsCountLabel.layer.cornerRadius = notificationsCountLabel.frame.size.width/2
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
    
    @IBAction func notificationsButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.hideLeftMenu(vc: self)
        BasicFunctions.pushVCinNCwithName("NotificationsVC", popTop: true)
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
    
//    func getNotificationsListFromServer()
//    {
//        BasicFunctions.showActivityIndicator(vu: self.view)
//        
//        var postParams = [String:Any]()
//        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
//        
//        ServerManager.getNotificationsData(postParams, withBaseURL : kBaseURL,accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
//            
//            
//            BasicFunctions.stopActivityIndicator(vu: self.view)
//            self.handleServerResponseOfNotificationsData(result as! [String : Any])
//            
//        }
//        
//    }
//    
//    func handleServerResponseOfNotificationsData(_ json: [String: Any])
//    {
//        let status = json["status"] as? String
//        let message = json["message"] as? String
//        
//        if message != nil && message == "Unauthorized"
//        {
//            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
//            BasicFunctions.showSigInVC()
//            return
//            
//        }
//        
//        if  json["error"] == nil && status == nil
//        {
//            let notificationCount = json["unReadNotification_count"] as! Int
//            
//            if notificationCount > 0
//            {
//                kNotificationCount = notificationCount
//                notificationsCountLabel.isHidden = false
//                notificationsCountLabel.text = String(notificationCount)
//            }
//            else
//            {
//                notificationsCountLabel.isHidden = true
//            }
//            
//            var notificationsArray : [[String : Any]]!
//            
//            
//            notificationsArray = json["notifications"] as? [[String : Any]]
//            
//            kNotificationsList.removeAll()
//            
//            for notification in notificationsArray
//            {
//                let notificationData = NotificationData()
//                notificationData.id = notification["id"] as? Int ?? 0
//                notificationData.notification_id = notification["notification_id"] as? Int ?? 0
//                notificationData.event_id = notification["event_id"] as? Int ?? 0
//                notificationData.sender_name = notification["sender_name"] as? String ?? ""
//                notificationData.related_screen = notification["related_screen"] as? String ?? ""
//                notificationData.read_status = notification["read_status"] as? Int ?? 0
//                notificationData.sender_image = notification["sender_image"] as? String ?? ""
//                notificationData.message = notification["message"] as? String ?? ""
//                
//                kNotificationsList.append(notificationData)
//                
//            }
//            
//        }
//        else if status == "error"
//        {
//            kNotificationsList.removeAll()
//            
//        }
//        else
//        {
//        
//            BasicFunctions.showAlert(vc: self, msg: message)
//        }
//        
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
