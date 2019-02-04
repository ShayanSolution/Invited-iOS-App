//
//  ContactCell.swift
//  Invited
//
//  Created by ShayanSolutions on 5/22/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var profileImageView: AsyncImageView!
    
    @IBOutlet var profileView: UIView!
    
    @IBOutlet var profileButton: UIButton!
    
    
    
    @IBOutlet var selectedIcon: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2
//        self.profileView.layer.borderWidth = 2.0
//        self.profileView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
