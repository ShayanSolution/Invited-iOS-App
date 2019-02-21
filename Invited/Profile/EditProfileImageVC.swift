//
//  EditProfileImageVC.swift
//  Invited
//
//  Created by ShayanSolutions on 1/17/19.
//  Copyright © 2019 ShayanSolutions. All rights reserved.
//

import UIKit

class EditProfileImageVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,EditImageDelegate {

    
    @IBOutlet var profileImageView: AsyncImageView!
    
    
    @IBOutlet var editButton: UIButton!
    
    
    var profileImage : UIImage!
    var userListObject : UserList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

//        self.profileImage = BasicFunctions.resizeImage(image: self.profileImage, targetSize: self.profileImageView.frame.size)

        self.profileImageView.image = self.profileImage
        
        if kIsDisplayOnlyImage
        {
            self.editButton.isHidden = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        kImage = self.profileImageView.image
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any)
    {
        BasicFunctions.openActionSheetWithDeleteOption(vc: self, isEditing: false)
    }
    
    // UiimagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var originalImage : UIImage?
        
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil
        {
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage

//            self.profileImageView.image = originalImage
            
            
        }
        
        dismiss(animated: true) {
            
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: originalImage!, cropMode: RSKImageCropMode.circle)
            imageCropVC.delegate = self
            imageCropVC.avoidEmptySpaceAroundImage = true
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
    }
    
    // RSKImageCropViewControllerDelegate Methods
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        self.profileImageView.image = croppedImage
        
        if self.userListObject != nil
        {
            self.uploadGroupImageOnServer(vc: controller)
        }
        else
        {
            self.uploadProfileImageOnServer(vc: controller)
        }
        
    }
    
    // RSKImageCropViewControllerDataSource Methods
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        
        return UIBezierPath(rect: controller.maskRect)
    }
    
    func uploadGroupImageOnServer(vc : UIViewController)
    {
        
        BasicFunctions.showActivityIndicator(vu: vc.view)
        
        var imageData : Data?
        
        var scaleImage : UIImage!
        scaleImage = BasicFunctions.resizeImage(image: self.profileImageView.image!, targetSize: CGSize.init(width: 320.0, height: 320.0))
        
        imageData = UIImagePNGRepresentation(scaleImage)
        
        var postParams = [String : Any]()
        postParams["list_id"] = self.userListObject!.id
        ServerManager.updateListImage(postParams, withBaseURL: kBaseURL, withImageData: imageData, accessToken: kLoggedInUserProfile.accessToken) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: vc.view)
            
            let json = result as? [String : Any]
            //            let msg = json["messages"] as? String
            
            let message = json?["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if json?["error"] == nil
            {
                AsyncImageLoader.defaultCache()?.removeAllObjects()
//                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
                //                BasicFunctions.showAlert(vc: self, msg: msg)
            }
            
        }
    }
    
    // Upload Profile Image on Server
    func uploadProfileImageOnServer(vc : RSKImageCropViewController)
    {
        BasicFunctions.showActivityIndicator(vu: vc.view)
        
        var postParams = [String : Any]()
        postParams["user_id"] = kLoggedInUserProfile.userID
        
        var imageData : Data?
        
        
            var scaleImage : UIImage!
            scaleImage = BasicFunctions.resizeImage(image: self.profileImageView.image!, targetSize: CGSize.init(width: 320.0, height: 320.0))
            
            imageData = UIImagePNGRepresentation(scaleImage)
        
        
        ServerManager.updateUserProfileImage(postParams, withBaseURL: kBaseURL, withImageData: imageData, accessToken: kLoggedInUserProfile.accessToken) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: vc.view)
            self.handleServerResponseOfUpdateProfileImage(json: result as? [String : Any])
            
            
        }
        
        
    }
    func handleServerResponseOfUpdateProfileImage(json : [String : Any]?)
    {
        
        let status = json?["status"] as? String
        let message = json?["message"] as? String
//        let msg = json?["messages"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if status == "success"
        {
            AsyncImageLoader.defaultCache()?.removeAllObjects()
//            self.navigationController?.popViewController(animated: true)
            kImage = self.profileImageView.image
            self.navigationController?.popToRootViewController(animated: true)
//            BasicFunctions.showAlert(vc: self, msg: msg)
            return
        }
        
        if message != nil
        {
            BasicFunctions.showAlert(vc: self, msg: message)
        }
        
    }
    
    
    //DeleteDelegateMethod
    func didDeleteImage()
    {
        if self.userListObject != nil
        {
            self.deleteGroupImageFromServer()
        }
        else
        {
            self.deleteProfileImageFromServer()
        }
    }
    
    func deleteGroupImageFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        
        var postParams = [String : Any]()
        postParams["list_id"] = self.userListObject!.id
        
        ServerManager.deleteListImage(postParams, withBaseURL: kBaseURL, accessToken: kLoggedInUserProfile.accessToken) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String:Any]
            
            let status = json?["status"] as? String
            let message = json?["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if status == "success"
            {
                AsyncImageLoader.defaultCache()?.removeAllObjects()
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            BasicFunctions.showAlert(vc: self, msg: message)
            
            
        }
    }
    
    func deleteProfileImageFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String : Any]()
        postParams["user_id"] = kLoggedInUserProfile.userID
        
        ServerManager.deleteProfileImage(postParams, withBaseURL: kBaseURL, accessToken: kLoggedInUserProfile.accessToken) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String:Any]
            
            let status = json?["status"] as? String
            let message = json?["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            if status == "success"
            {
                AsyncImageLoader.defaultCache()?.removeAllObjects()
                self.getProfileFromServer()
            }
            else
            {
                BasicFunctions.showAlert(vc: self, msg: message)
            }
            
        }
    }
    
    func getProfileFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        ServerManager.getUserProfile(nil, withBaseURL : kBaseURL,accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfGetProfile(json: result as? [String : Any])
            
        }
    }
    func handleServerResponseOfGetProfile(json : [String : Any]?)
    {
        let message = json?["message"] as? String
        let userData = json?["user"] as? [String : Any]
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if json?["error"] == nil && userData != nil
        {
            
            let dobString = userData?["dob"] as? String ?? ""
            let dorString = userData?["dateofrelation"] as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = dateFormatter.date(from: dobString)
            let dorDate = dateFormatter.date(from: dorString)
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let userProfileData = UserProfileData()
            userProfileData.authID = userData?["id"] as? Int ?? 0
            userProfileData.authToken = BasicFunctions.getPreferences(kAccessToken) as? String ?? ""
            userProfileData.firstName = userData?["firstName"] as? String ?? ""
            userProfileData.lastName = userData?["lastName"] as? String ?? ""
            userProfileData.gender = userData?["gender_id"] as? Int ?? 0
            userProfileData.email = userData?["email"] as? String ?? ""
            userProfileData.imageURL = userData?["profileImage"] as? String ?? ""
            userProfileData.createdAt = userData?["created_at"] as? String ?? ""
            userProfileData.updatedAt = userData?["updated_at"] as? String ?? ""
            
            if dobDate != nil
            {
                userProfileData.dob = dateFormatter.string(from: dobDate!)
            }
            
            if dorDate != nil
            {
                userProfileData.dor = dateFormatter.string(from: dorDate!)
            }
            
            
            let userProfile = UserProfile.init(id: userProfileData.authID, accessToken: userProfileData.authToken, firstName: userProfileData.firstName, lastName: userProfileData.lastName, gender: userProfileData.gender, email: userProfileData.email, imageURL : userProfileData.imageURL, dob: userProfileData.dob, dor: userProfileData.dor, createdAt: userProfileData.createdAt, updatedAt: userProfileData.updatedAt)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userProfile)
            BasicFunctions.setPreferences(encodedData, key: kUserProfile)
            
            kLoggedInUserProfile = NSKeyedUnarchiver.unarchiveObject(with: BasicFunctions.getPreferences(kUserProfile) as! Data) as! UserProfile
            
            self.profileImageView.image = nil
            kImage = nil
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else if message != nil
        {
            BasicFunctions.showAlert(vc: self, msg: message!)
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
