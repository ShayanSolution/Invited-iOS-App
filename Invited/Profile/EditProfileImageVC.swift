//
//  EditProfileImageVC.swift
//  Invited
//
//  Created by ShayanSolutions on 1/17/19.
//  Copyright © 2019 ShayanSolutions. All rights reserved.
//

import UIKit

class EditProfileImageVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var profileImageView: AsyncImageView!
    
    
    var profileImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if self.profileImage.size.width < self.profileImageView.frame.size.width
//        {
//            self.profileImage = BasicFunctions.resizeImage(image: self.profileImage, targetSize: self.profileImageView.frame.size)
//        }
        self.profileImageView.image = profileImage
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any)
    {
        BasicFunctions.openActionSheet(vc: self, isEditing: true)
    }
    
    // UiimagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil
        {
            kImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            self.profileImageView.image = kImage
            
            
        }
        
        dismiss(animated: true, completion: nil)
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
