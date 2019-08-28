//
//  NotificationsVC.swift
//  Invited
//
//  Created by user on 8/19/19.
//  Copyright © 2019 ShayanSolutions. All rights reserved.
//

import UIKit


class NotificationsVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var notificationsTableView: UITableView!
    
    @IBOutlet var notificationCountLabel: UILabel!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AsyncImageLoader.defaultCache()?.removeAllObjects()
        
//        self.notificationsTableView.register(UINib.init(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationCount), name: Notification.Name("UpdateNotificationCount"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        self.notificationCountLabel.layer.cornerRadius = self.notificationCountLabel.frame.size.width/2
        self.notificationCountLabel.layer.masksToBounds = true
        
//        BasicFunctions.getNotificationsListFromServer { (notificationCount) in
        
            if kNotificationCount > 0
            {
                self.notificationCountLabel.isHidden = false
                self.notificationCountLabel.text = String(kNotificationCount)
            }
            else
            {
                self.notificationCountLabel.isHidden = true
            }
            
//        }
    }
    @objc func appDidBecomeActive()
    {
        kCity = nil
        BasicFunctions.hideLeftMenu(vc: self)
//        BasicFunctions.pushVCinNCwithName("HomeVC", popTop: true)
    }
    @objc func updateNotificationCount()
    {
        if kNotificationCount != nil
        {
            if kNotificationCount > 0
            {
                self.notificationCountLabel.isHidden = false
                self.notificationCountLabel.text = String(kNotificationCount)
            }
            else
            {
                self.notificationCountLabel.isHidden = true
            }
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.openLeftMenu(vc: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return kNotificationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as? NotificationsCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("NotificationsCell", owner: nil, options: nil)?[0] as? NotificationsCell
        }
        
        let notification = kNotificationsList[indexPath.row]
        
        if notification.read_status == 0
        {
            cell?.containerView.backgroundColor = UIColor.init(red: 208/255, green: 0/255, blue: 11/255, alpha: 0.5)
        }
        else
        {
            cell?.containerView.backgroundColor = UIColor.white
        }
        
        if notification.sender_image != ""
        {
           cell?.profileImageView.imageURL = URL.init(string: notification.sender_image)
        }
        cell?.titleLabel.text = String(format: "%@ %@:", notification.sender_name,notification.related_screen)
        cell?.messageLabel.text = notification.message
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let notification = kNotificationsList[indexPath.row]
        
        if notification.read_status == 0
        {
            self.sendNotificationDataToServer(notificationData: notification)
        }
        else
        {
            kNotificationData = notification
            BasicFunctions.pushVCinNCwithName("HomeVC", popTop: true)
        }
    }
    
    func sendNotificationDataToServer(notificationData:NotificationData)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["notification_id"] = notificationData.id
        
        ServerManager.readNotification(postParams, withBaseURL : kBaseURL,accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            kNotificationData = notificationData
            BasicFunctions.pushVCinNCwithName("HomeVC", popTop: true)
            
        }
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
