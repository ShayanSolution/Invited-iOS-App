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
import SQLite3
import PGSideMenu

extension NSObject {
var className: String {
    return String(describing: type(of: self))
}
    
}

extension UIViewController {
    var vcClassName: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
}

protocol EditImageDelegate:class {
    func didDeleteImage()
}


class BasicFunctions: NSObject {
    
    static weak var delegate: EditImageDelegate?
    
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
        _ = MBProgressHUD.showAdded(to: vu, animated: true)
        
    }
    class func stopActivityIndicator(vu : UIView) -> Void
    {
        MBProgressHUD.hide(for: vu, animated: true)
        
        
    }
    class func deletePhoto(vc:UIViewController!) -> Void
    {
        
        self.delegate = vc as! EditProfileImageVC
        
        self.delegate?.didDeleteImage()
    }
    class func openPhotoLibrary(vc:UIViewController!, isEditing:Bool!) -> Void
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = vc as! (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
        imagePicker.allowsEditing = isEditing
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            
        }
        vc.present(imagePicker, animated: true, completion: nil)
        
    }
    class func openCamera(vc:UIViewController!, isEditing:Bool!) -> Void
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = vc as! (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
        imagePicker.allowsEditing = isEditing
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            
        }
        vc.present(imagePicker, animated: true, completion: nil)
        
    }
    class func openActionSheet(vc:UIViewController!, isEditing:Bool!)
    {
        var alert = UIAlertController()
        
        alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.openCamera(vc: vc, isEditing: isEditing)
        }))
        alert.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.openPhotoLibrary(vc: vc, isEditing: isEditing)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
            //Plus whatever method you define here, gets called,
            //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    class func openActionSheetWithDeleteOption(vc:UIViewController!, isEditing:Bool!)
    {
        var alert = UIAlertController()
        
        alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Delete Photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.deletePhoto(vc: vc)
        }))
        alert.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.openCamera(vc: vc, isEditing: isEditing)
        }))
        alert.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.default, handler: { (action) in
            self.openPhotoLibrary(vc: vc, isEditing: isEditing)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
            //Plus whatever method you define here, gets called,
            //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    class func showSigInVC()
    {
        BasicFunctions.setBoolPreferences(false, forkey: kIfUserLoggedIn)
        BasicFunctions.removePreferences(kBaseURLInPrefrences)
        BasicFunctions.removePreferences(kUserID)
        BasicFunctions.removePreferences(kAccessToken)
        BasicFunctions.removePreferences(kUserProfile)
        
        kLoggedInUserProfile = nil
        
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
    class func removePreferences(_ key:String!)
    {
        let defaults : UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
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
    class func openLeftMenu(vc : UIViewController!)
    {
        if let sideMenuController = vc.navigationController!.parent as? PGSideMenu {
            sideMenuController.toggleLeftMenu()
        }
    }
    class func hideLeftMenu(vc : UIViewController!)
    {
        if let sideMenuController = vc.parent as? PGSideMenu {
            sideMenuController.toggleLeftMenu()
        }
    }
    class func convertSelectedDataintoJson(contactList : [ContactData]) -> String
    {
        
        var jsonFormSelectedContactList = [[String : Any]]()
        
        for contact in contactList
        {
            var contactDic = [String: Any]()
            contactDic["name"] = BasicFunctions.getNameFromContactList(phoneNumber: contact.phoneNumber)
            
            contactDic["phone"] = contact.phoneNumber.stringByRemovingWhitespaces
            
            
            jsonFormSelectedContactList.append(contactDic)
            
        }
        
        let jsonString = self.convertToJsonString(from: jsonFormSelectedContactList)
        
        
        return jsonString!
    }
    class func convertToJsonString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    class func getTitleAccordingToDateAndTimeFormat (dateTimeString : String!) -> String
    {
        var titleString = "Date and time of event: "
        if dateTimeString.range(of: "-") != nil && dateTimeString.range(of: ":") != nil
        {
            
        }
        else if dateTimeString.range(of: "-") != nil
        {
            titleString = "Date of event: "
        }
        else if dateTimeString.range(of: ":") != nil
        {
            titleString = "Time of event: "
        }
        return titleString
    }
    class func checkFormat(dateTimeString : String!) -> String
    {
        let dateformatter = DateFormatter()
        
        
        var formatedString = ""
        
        if dateTimeString.range(of: "-") != nil && dateTimeString.range(of: ":") != nil
        {
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateformatter.date(from: dateTimeString)
            {
                dateformatter.dateStyle = .medium
                dateformatter.timeStyle = .short
                formatedString = dateformatter.string(from: date)
            }
            
        }
        else if dateTimeString.range(of: "-") != nil
        {
            dateformatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateformatter.date(from: dateTimeString)
            {
//                let outputFormatter = DateFormatter()
//                outputFormatter.dateFormat = "dd-MM-yyyy"
                
                dateformatter.dateStyle = .medium
            
                formatedString = dateformatter.string(from: date)
            }
        }
        else if dateTimeString.range(of: ":") != nil
        {
            dateformatter.dateFormat = "HH:mm:ss"
            if let date = dateformatter.date(from: dateTimeString)
            {
                dateformatter.timeStyle = .short
                formatedString = dateformatter.string(from: date)
            }
        }
        
        
        
        return formatedString
    }
    class func compareDates(fromDate : Date!, toDate : Date!) -> Int
    {
        let components = Calendar.current.dateComponents([.year], from: fromDate, to: toDate)
        
        return components.year!
    }
    
    
    class func setHomeVC()
    {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let homeNC = (storyBoard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController)
//
//        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = homeNC
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeNC = (storyBoard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController)
        let leftMenuVC = storyBoard.instantiateViewController(withIdentifier: "LeftMenuVC") as? LeftMenuVC
        let sideMenuController = PGSideMenu(animationType: .slideIn)
        let contentController = homeNC
        let leftMenuController = leftMenuVC
        sideMenuController.addContentController(contentController!)
        sideMenuController.addLeftMenuController(leftMenuController!)
        sideMenuController.enableMenuPanGesture = false
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = sideMenuController
        
    }
    class func showSettingsAlert(vc:UIViewController!, msg:String!)
    {
        let alert = UIAlertController.init(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { action in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Don't Allow", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    class func pushVCinNCwithName(_ vcName: String?, popTop: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var navController = appDelegate?.window?.rootViewController as? UINavigationController
        if navController == nil
        {
            navController = (appDelegate?.window?.rootViewController as? PGSideMenu)?.contentController as? UINavigationController
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
            navController = (appDelegate?.window?.rootViewController as? PGSideMenu)?.contentController as? UINavigationController
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
        
        var id : Int32 = 0
        let db = self.openDatabase()
        self.createTable(db: db)
        
        
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
            
            
            for contact in results
            {
                
                let contactData = ContactData()
                contactData.name = contact.givenName + " " + contact.familyName
                //            contactData.phoneNumber = ((contact.phoneNumbers.first?.value)?.stringValue)!
                if contact.isKeyAvailable(CNContactPhoneNumbersKey)
                {
                    let phoneNOs=contact.phoneNumbers
                    for item in phoneNOs
                    {
//                        print(item.value.stringValue)
                        contactData.phoneNumber = item.value.stringValue
                    }
                }
                
//                if let imageData = contact.thumbnailImageData {
////                    print("image \(String(describing: UIImage(data: imageData)))")
//                    contactData.imageData = imageData
//
//                } else {
//                    print("No image available")
//                }
                
//                if kContactList.contains(where: { $0.phoneNumber.stringByRemovingWhitespaces.suffix(9) == contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) }) && kContactList.contains(where: { $0.name == contactData.name })
//                {
//
//                }
//                else
//                {
//                    kContactList.append(contactData)
//                }
                if contactData.phoneNumber != ""
                {
                    id = id + 1
                    self.insert(id : id, name: contactData.name as NSString, phone: contactData.phoneNumber as NSString, db: db)
                }
                
                
            }
            
            return results
        }()
        } else {
            // Fallback on earlier versions
        }


}
    class func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                      .appendingPathComponent("PhoneContacts.sqlite")
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        } else {
            print("Unable to open database.")
            
        }
        return nil
    }
    class func createTable(db : OpaquePointer?) {
        
        
        let createTableString = """
                                CREATE TABLE IF NOT EXISTS Contact(Id INT PRIMARY KEY NOT NULL,
                                Name CHAR(255), Phone CHAR(255));
                                """


        
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
        
        self.delete(db: db)
    }
    class func insert(id : Int32 , name : NSString , phone : NSString , db : OpaquePointer?) {
        
    
        let insertStatementString = "INSERT INTO Contact (Id,Name, Phone) VALUES (?, ?, ?);"
        
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_reset(insertStatement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error resetting prepared statement: \(errmsg)")
            }
        
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, phone.utf8String, -1, nil)
            
//            var strBase64 : NSString!
//
//            if imageData != nil
//            {
//                strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters) as NSString
//                sqlite3_bind_text(insertStatement, 4, strBase64.utf8String, -1, nil)
//            }
//            else
//            {
//                sqlite3_bind_text(insertStatement, 4, strBase64.utf8String, -1, nil)
//            }
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    class func delete(db : OpaquePointer?) {
        
        let db = self.openDatabase()
        
        let deleteStatementStirng = "DELETE FROM Contact;"

        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    class func query()
    {
        
        kContactList.removeAll()
        
        let db = BasicFunctions.openDatabase()
        
        let queryStatementString = "SELECT * FROM Contact;"
        
        
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while(sqlite3_step(queryStatement) == SQLITE_ROW){
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let phone = String(cString: queryResultCol2!)
                
//                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
//                let imageDataString = String(cString: queryResultCol3!)
                
                
                print("\(name) | \(phone)")
                
                let contactData = ContactData()
                contactData.name = name
                contactData.phoneNumber = phone.stringByRemovingWhitespaces
                
//                if imageDataString != ""
//                {
//                    contactData.imageData = Data(base64Encoded: imageDataString, options: .ignoreUnknownCharacters)!
//                }
                
                kContactList.append(contactData)
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
    }


//    class func storeDataInDB()
//    {
//        let db = self.openDatabase()
//
//    
//        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Contacts ( id INTEGER PRIMARY KEY AUTOINCREMENT ,name CHAR(255), phone CHAR(255))", nil, nil, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error creating table: \(errmsg)")
//        }
//
//        var stmt: OpaquePointer?
//        if sqlite3_prepare_v2(db, "DELETE FROM Contacts", -1, &stmt, nil) == SQLITE_OK {
//            if sqlite3_step(stmt) == SQLITE_DONE {
//                print("Successfully deleted row.")
//            } else {
//                print("Could not delete row.")
//            }
//        } else {
//            print("DELETE statement could not be prepared")
//        }
//
//
//
//
//        for contactData in kContactList
//        {
//            var stmt: OpaquePointer?
//
//            let queryString = "INSERT INTO Contacts (name, phone) VALUES (?,?)"
//
//            if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("error preparing insert: \(errmsg)")
//            }
//
//            if sqlite3_reset(stmt) != SQLITE_OK {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("error resetting prepared statement: \(errmsg)")
//            }
//
////            let name: NSString = contactData.name as NSString
////            let phone: NSString = contactData.phoneNumber as NSString
//
//            if sqlite3_bind_text(stmt, 1, contactData.name, -1, nil) != SQLITE_OK{
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("failure binding name: \(errmsg)")
//                return
//            }
//
//            if sqlite3_bind_text(stmt, 2, contactData.phoneNumber, -1, nil) != SQLITE_OK{
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("failure binding phone: \(errmsg)")
//                return
//            }
//
//
//
//            if sqlite3_step(stmt) != SQLITE_DONE {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("failure inserting contact: \(errmsg)")
//                return
//            }
//
//            if sqlite3_finalize(stmt) != SQLITE_OK {
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("error finalizing prepared statement: \(errmsg)")
//            }
//
//            stmt = nil
//
//
//        }
//
//        kContactList.removeAll()
//    }
    
    class func getNameFromContactList(phoneNumber : String) -> String
    {
        if kContactList.count > 0
        {
        for contctData in kContactList
        {
            contctData.phoneNumber = contctData.phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
            let phone = phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
            if contctData.phoneNumber.stringByRemovingWhitespaces.suffix(9) == phone.stringByRemovingWhitespaces.suffix(9)
            {
                
                return contctData.name
            }
        }
        }
        
        
        return " "
        
    }
    
    
    
//    class func getImageDataFromContactList(phoneNumber : String) -> Data
//    {
//        if kContactList.count > 0
//        {
//            for contactData in kContactList
//            {
//                contactData.phoneNumber = contactData.phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
//                let phone = phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
//                if contactData.phoneNumber.stringByRemovingWhitespaces.suffix(9) == phone.stringByRemovingWhitespaces.suffix(9)
//                {
//                    return contactData.imageData
//                }
//            }
//        }
//
//
//        return Data()
//
//    }
    
    
}

        
        
    
    

