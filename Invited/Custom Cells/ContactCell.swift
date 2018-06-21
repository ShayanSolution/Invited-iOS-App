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
    
    
    
    @IBOutlet var selectedIcon: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
