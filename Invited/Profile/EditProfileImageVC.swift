//
//  EditProfileImageVC.swift
//  Invited
//
//  Created by ShayanSolutions on 1/17/19.
//  Copyright © 2019 ShayanSolutions. All rights reserved.
//

import UIKit

class EditProfileImageVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate {
    
    
    @IBOutlet var profileImageView: AsyncImageView!
    
    
    var profileImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        self.profileImage = BasicFunctions.resizeImage(image: self.profileImage, targetSize: self.profileImageView.frame.size)

        self.profileImageView.image = self.profileImage
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any)
    {
        BasicFunctions.openActionSheet(vc: self, isEditing: false)
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
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
    }
    
    // RSKImageCropViewControllerDelegate Methods
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        kImage = croppedImage
        self.profileImageView.image = kImage
        self.navigationController?.popViewController(animated: true)
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
