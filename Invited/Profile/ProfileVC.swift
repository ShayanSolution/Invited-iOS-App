//
//  ProfileVC.swift
//  Invited
//
//  Created by ShayanSolutions on 12/26/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

class ProfileVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate {
    
    @IBOutlet var profileScrollView: UIScrollView!
    
    @IBOutlet var firstNameTextField: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var genderTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var dobTextField: UITextField!
    
    @IBOutlet var dorTextField: UITextField!
    
    @IBOutlet var profileView: UIView!
    
    
    @IBOutlet var profileImageView: AsyncImageView!
    
    
    @IBOutlet var editButton: UIButton!
    
    
    let dobPicker = UIDatePicker()
    let dorPicker = UIDatePicker()
    
    let dateFormatter = DateFormatter()
    
    let currentDate = Date()
    
    let genderList = ["Select Gender","Male","Female"]
    
    let dropDownPickerView = UIPickerView()
    
//    var profileImage : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        kImage = nil
        
        self.firstNameTextField.text = kLoggedInUserProfile.firstName
        self.lastNameTextField.text = kLoggedInUserProfile.lastName
        self.emailTextField.text = kLoggedInUserProfile.email
        self.dobTextField.text = kLoggedInUserProfile.dob
        self.dorTextField.text = kLoggedInUserProfile.dor
        
//        if kLoggedInUserProfile.imageURL != ""
//        {
//            self.profileImageView.imageURL = URL.init(string: kLoggedInUserProfile.imageURL!)
////            self.profileImage = self.profileImageView.image
//            self.editButton.isHidden = false
//        }
//        else
//        {
//            self.profileImageView.image = UIImage.init(named: "AddPhoto")
//            self.editButton.isHidden = true
//        }
        
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        var updatedDate : Date!

        if kLoggedInUserProfile.updatedAt != ""
        {
            updatedDate = self.dateFormatter.date(from: kLoggedInUserProfile.updatedAt!)
        }
        else if kLoggedInUserProfile.createdAt != ""
        {
            updatedDate = self.dateFormatter.date(from: kLoggedInUserProfile.createdAt!)
        }




        var year : Int!

        if updatedDate != nil
        {
            year = BasicFunctions.compareDates(fromDate: updatedDate, toDate: currentDate)
        }

        if year < 1
        {
            if kLoggedInUserProfile.dob != ""
            {
                self.dobTextField.isUserInteractionEnabled = false
            }

            if kLoggedInUserProfile.dor != ""
            {
                self.dorTextField.isUserInteractionEnabled = false
            }
        }
        
        self.showPicker(textField: self.genderTextField)
        self.showDatePicker(textField: self.dobTextField)
        self.showDatePicker(textField: self.dorTextField)
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        self.profileScrollView.contentSize.height = 700.0
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if kImage != nil
        {
//            self.profileImage = kImage
            self.profileImageView.image = kImage
            self.editButton.isHidden = false
        }
        else if kImage == nil && (kLoggedInUserProfile.imageURL?.isEmpty)!
        {
            self.profileImageView.image = UIImage.init(named: "AddPhoto")
            self.editButton.isHidden = true
        }
        else if kImage == nil && kLoggedInUserProfile.imageURL != ""
        {
            self.profileImageView.imageURL = URL.init(string: kLoggedInUserProfile.imageURL!)
            //            self.profileImage = self.profileImageView.image
            self.editButton.isHidden = false
            kImage = self.profileImageView.image
        }
        
    }
    override func viewDidLayoutSubviews()
    {
        self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2
//        self.profileView.layer.borderWidth = 5.0
//        self.profileView.layer.borderColor = UIColor.lightGray.cgColor
    }
//    @objc func receivedNotification(notification : Notification)
//    {
////        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
////        let homeVC : HomeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
////
////        homeVC.isNotificationReceived = true
//
//        kISNotificationReceived = true
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        BasicFunctions.openLeftMenu(vc: self)
    }
    
    @IBAction func editButtonTapped(_ sender: Any)
    {
        if kImage != nil
        {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let editProfileImageVC : EditProfileImageVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileImageVC") as! EditProfileImageVC
            editProfileImageVC.profileImage = self.profileImageView.image
            BasicFunctions.pushVCinNCwithObject(vc: editProfileImageVC, popTop: false)
        }
        else
        {
            BasicFunctions.openActionSheet(vc: self, isEditing: false)
        }
    }
    
    
    @IBAction func updateButtonTapped(_ sender: UIButton)
    {
//        self.dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateObj = self.dateFormatter.date(from: self.dobTextField.text!)
//        
//        var dobDateString : String!
//        if dateObj != nil
//        {
//            dobDateString = self.dateFormatter.string(from: dateObj!)
//        }
//        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        let dobTimesTamp = self.dateFormatter.date(from: dobDateString)
//        
//        let year = BasicFunctions.compareDates(fromDate: currentDate, toDate: dobTimesTamp)
    
        if self.firstNameTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put first name.")
            return
        }
        else if self.lastNameTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put last name.")
            return
        }
        else if (self.genderTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put gender.")
            return
        }
        else if self.emailTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put email.")
            return
        }
        else if self.dobTextField.text == ""
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put date of birth.")
            return
        }
        else if !(self.emailTextField.text?.isValidEmail())!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put valid email.")
            return
        }
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var postParams = [String : Any]()
        postParams["user_id"] = kLoggedInUserProfile.userID
        postParams["firstName"] = self.firstNameTextField.text
        postParams["lastName"] = self.lastNameTextField.text
        postParams["email"] = self.emailTextField.text
        
        var gender : Int!
        
        if self.genderTextField.text == "Male"
        {
            gender = 1
        }
        else
        {
            gender = 2
        }
        
        postParams["gender"] = gender
        
        var date = self.dateFormatter.date(from: self.dobTextField.text!)
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        if date != nil
        {
            postParams["dob"] = self.dateFormatter.string(from: date!)
        }
        else
        {
            postParams["dob"] = ""
        }
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        date = self.dateFormatter.date(from: self.dorTextField.text!)
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if date != nil
        {
            postParams["dateofrelation"] = self.dateFormatter.string(from: date!)
        }
        else
        {
            postParams["dateofrelation"] = ""
        }
        
        
        
        ServerManager.updateUserProfile(postParams, withBaseURL : kBaseURL, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfUpdateProfile(json: result as? [String : Any])
            
        }
        
    }
    
    func handleServerResponseOfUpdateProfile(json : [String : Any]?)
    {
        
//        let status = json?["status"] as? String
        let message = json?["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if json?["email"] != nil
        {
            let errorString : String = (json!["email"] as! Array)[0]
            BasicFunctions.showAlert(vc: self, msg: errorString)
            return
        }
        
        BasicFunctions.showAlert(vc: self, msg: message)
        self.view.endEditing(true)
        
//        if json?["error"] == nil && status != nil
//        {
//            BasicFunctions.showAlert(vc: self, msg: message)
//        }
//        else
//        {
//            BasicFunctions.showAlert(vc: self, msg: message)
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func showDatePicker(textField:UITextField!){
        
        let dateString = String(format: "%@/%@/1990", currentDate.day,currentDate.month)
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        
        
        
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
        
        
        if textField.tag == 1
        {
            self.dobPicker.datePickerMode = .date
            
            let date = self.dateFormatter.date(from: self.dobTextField.text!)
            
            
            if date != nil
            {
                self.dobPicker.date = date!
            }
            else
            {
                //                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let date = self.dateFormatter.date(from: dateString)
                
                if date != nil
                {
                    self.dobPicker.date = date!
                }
            }
            
            
            // add datepicker to textField
            textField.inputView = self.dobPicker
        }
        else
        {
            self.dorPicker.datePickerMode = .date
            
            let date = self.dateFormatter.date(from: self.dorTextField.text!)
            
            
            if date != nil
            {
                self.dorPicker.date = date!
            }
            else
            {
                //                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let date = self.dateFormatter.date(from: dateString)
                
                if date != nil
                {
                    self.dorPicker.date = date!
                }
            }
            
            // add datepicker to textField
            textField.inputView = self.dorPicker
        }
        
    }
    
    @objc func donedatePicker(sender : UIBarButtonItem){
        
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if sender.tag == 1
        {
            self.dobTextField.text = self.dateFormatter.string(from: self.dobPicker.date)
        }
        else
        {
            self.dorTextField.text = self.dateFormatter.string(from: self.dorPicker.date)
        }
        
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        
        self.view.endEditing(true)
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
        
        
        if kLoggedInUserProfile.gender == 0
        {
            self.genderTextField.text = ""
            self.dropDownPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        else if kLoggedInUserProfile.gender == 1
        {
            self.genderTextField.text = "Male"
            self.dropDownPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        else
        {
            self.genderTextField.text = "Female"
            self.dropDownPickerView.selectRow(2, inComponent: 0, animated: false)
        }
        
        
        
        textField.inputView = self.dropDownPickerView
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick()
    {
        self.view.endEditing(true)
    }
    
    // UiPickerView delegate Methods
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
    
    
    // UiimagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var originalImage : UIImage?
        
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil
        {
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
//            if Float((pickedImage?.size.height)!) < 64.0
//            {
//                pickedImage = BasicFunctions.resizeImage(image: pickedImage!, targetSize: CGSize.init(width: 64.0, height: 64.0))
//            }
            
//            self.profileImageView.image = self.profileImage
//            self.editButton.isHidden = false
            
            
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
        
        kImage = croppedImage
        self.uploadProfileImageOnServer(vc: controller)
    }
    
    // RSKImageCropViewControllerDataSource Methods
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        
        return UIBezierPath(rect: controller.maskRect)
    }
    
    // Upload Profile Image on Server
    func uploadProfileImageOnServer(vc : RSKImageCropViewController)
    {
        BasicFunctions.showActivityIndicator(vu: vc.view)
        
        var postParams = [String : Any]()
        postParams["user_id"] = kLoggedInUserProfile.userID
        
        var imageData : Data?
        
        if kImage != nil
        {
            var scaleImage : UIImage!
            scaleImage = BasicFunctions.resizeImage(image: kImage!, targetSize: CGSize.init(width: 320.0, height: 320.0))
            
            imageData = UIImagePNGRepresentation(scaleImage)
        }
        
        ServerManager.updateUserProfileImage(postParams, withBaseURL: kBaseURL, withImageData: imageData, accessToken: kLoggedInUserProfile.accessToken) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: vc.view)
            self.handleServerResponseOfUpdateProfileImage(json: result as? [String : Any])
            
            
        }
        
        
    }
    func handleServerResponseOfUpdateProfileImage(json : [String : Any]?)
    {
        
        let status = json?["status"] as? String
        let message = json?["message"] as? String
        let msg = json?["messages"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if status == "success"
        {
            self.navigationController?.popViewController(animated: true)
            BasicFunctions.showAlert(vc: self, msg: msg)
            return
        }
        
        if message != nil
        {
            BasicFunctions.showAlert(vc: self, msg: message)
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
