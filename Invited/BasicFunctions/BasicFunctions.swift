//
//  BasicFunctions.swift
//  Invited
//
//  Created by ShayanSolutions on 5/21/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMaps
import Contacts
//import CoreLocation

extension NSObject {
var className: String {
    return String(describing: type(of: self))
}
    
}


class BasicFunctions: NSObject {
    
    class func setBorderOfView(view:UIView) -> Void {
        view.layer.cornerRadius = 2.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).cgColor
        
    }
    
    class func setRoundCornerOfView(view:UIView , radius : CGFloat) -> Void {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        
    }
    class func setRoundCornerOfButton(button:UIButton, radius : CGFloat!) -> Void {
        button.layer.cornerRadius = radius
        button.clipsToBounds = true
    }
    
    class func setRoundCornerOfImageView(imageView:UIImageView) -> Void {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2.0
        imageView.clipsToBounds = true
    }
    
    class func setborderOfButton(button:UIButton , color : UIColor!) -> Void {
        
        button.layer.borderWidth = 2.0
        button.layer.borderColor = color.cgColor
        button.backgroundColor = UIColor.clear
    }
    class func setLeftPaddingOfTextField(textField:UITextField , padding:CGFloat) -> Void
    {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: 2))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
    }
    class func showActivityIndicator(vu : UIView) -> Void
    {
        let hud = MBProgressHUD.showAdded(to: vu, animated: true)
        
        
        
    }
    class func stopActivityIndicator(vu : UIView) -> Void
    {
        MBProgressHUD.hide(for: vu, animated: true)
        
        
    }
    class func showSigInVC()
    {
        BasicFunctions.setBoolPreferences(false, forkey: kIfUserLoggedIn)
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LogInNC")
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        
    }
    class func setUserLoggedIn()
    {
        let defaults : UserDefaults = UserDefaults.standard
        
        defaults.set(true, forKey: kIfUserLoggedIn)
        defaults.synchronize()
    }
    class func getIfUserLoggedIn() -> Bool
    {
        let defaults : UserDefaults = UserDefaults.standard
        return defaults.bool(forKey: kIfUserLoggedIn)
        
    }
    class func setPreferences(_ value:Any!, key:String) {
        let defaults : UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    class func getPreferences(_ key:String!) -> Any! {
        let defaults : UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key) as Any!
    }
    class func getPreferencesForInt(_ key:String!) -> Int! {
        let defaults : UserDefaults = UserDefaults.standard
        return defaults.integer(forKey: key)
    }
    class func showAlert(vc:UIViewController!, msg:String!)
    {
        let alertController = UIAlertController(title:nil , message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
        
    }
    class func setBoolPreferences(_ val:Bool,forkey key:String!){
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(val, forKey: key)
        userDefault.synchronize()
    }
    
    class func getBoolPreferences(_ key:String!) -> Bool {
        let userDefault:UserDefaults = UserDefaults.standard
        return userDefault.bool(forKey: key)
    }
    
    class func setHomeVC()
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeNC = (storyBoard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController)
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = homeNC
    }
    
    class func pushVCinNCwithName(_ vcName: String?, popTop: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var navController = appDelegate?.window?.rootViewController as? UINavigationController
        if navController == nil
        {
            navController = appDelegate?.window?.rootViewController as? UINavigationController
        }
        let topVC : UIViewController?  = navController?.visibleViewController
        if (topVC?.className == vcName) {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController? = storyboard.instantiateViewController(withIdentifier: vcName ?? "")
        //  if (popTop) [navController popViewControllerAnimated:NO];
        if let aVc = vc {
            navController?.pushViewController(aVc, animated: true)
        }
        if popTop {
            var navigationArray = navController?.viewControllers
            
            for i in 0...navigationArray!.count {
                if (navigationArray![i].isKind(of: (topVC?.classForCoder)!)) {
                    navigationArray?.remove(at: i)
                    break
                }
            }
            if let anArray = navigationArray {
                navController?.setViewControllers(anArray, animated: false)
            }
        }
        
    }
    
    class func pushVCinNCwithObject(vc: UIViewController?, popTop: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var navController = appDelegate?.window?.rootViewController as? UINavigationController
        if navController == nil
        {
            navController = appDelegate?.window?.rootViewController as? UINavigationController
        }
        let topVC : UIViewController?  = navController?.visibleViewController
        if (topVC?.className == vc?.className) {
            return
        }
        
        navController?.pushViewController(vc!, animated: true)

        if popTop {
            var navigationArray = navController?.viewControllers
            
            for i in 0...navigationArray!.count {
                if (navigationArray![i].isKind(of: (topVC?.classForCoder)!)) {
                    navigationArray?.remove(at: i)
                    break
                }
            }
            if let anArray = navigationArray {
                navController?.setViewControllers(anArray, animated: false)
            }
        }
        
    }
    
    
    class func fetchAllContactsFromDevice()  {
        
        
        if #available(iOS 9.0, *) {
            var results = [CNContact]()
        
        
        
        var contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                    //                        self.storeDataInModelObjects()
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            kContactList.removeAll()
            
            for contact in results
            {
                let contactData = ContactData()
                contactData.name = contact.givenName + " " + contact.familyName
                //            contactData.phoneNumber = ((contact.phoneNumbers.first?.value)?.stringValue)!
                if contact.isKeyAvailable(CNContactPhoneNumbersKey){
                    let phoneNOs=contact.phoneNumbers
                    for item in phoneNOs
                    {
                        contactData.phoneNumber = item.value.stringValue
                    }
                }
                
                
                kContactList.append(contactData)
            }

            
            return results
        }()
        } else {
            // Fallback on earlier versions
        }


}
    class func getNameFromContactList(phoneNumber : String) -> String
    {
        
        for contctData in kContactList
        {
            if contctData.phoneNumber.stringByRemovingWhitespaces.suffix(9) == phoneNumber.stringByRemovingWhitespaces.suffix(9)
            {
                return contctData.name
            }
        }
        
        
        return " "
        
    }
    
    
}

        
        
    
    

