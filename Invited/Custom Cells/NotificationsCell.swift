//
//  NotificationsCell.swift
//  Invited
//
//  Created by user on 8/20/19.
//  Copyright © 2019 ShayanSolutions. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell
{
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImageView: AsyncImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        BasicFunctions.setRoundCornerOfImageView(imageView: self.profileImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
