//
//  RequestEventCell.swift
//  Invited
//
//  Created by ShayanSolutions on 6/1/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class RequestEventCell: UITableViewCell {
    
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var acceptButton: UIButton!
    
    @IBOutlet var rejectButton: UIButton!
    
    @IBOutlet var eventName: UILabel!
    
    @IBOutlet var createdBy: UILabel!
    
    @IBOutlet var totalInvited: UILabel!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var listName: UILabel!
    
    @IBOutlet var eventCreatedDate: UILabel!
    
    @IBOutlet var address: UILabel!
    
    
    @IBOutlet var startNavigationButton: UIButton!
    
    
    @IBOutlet var expandButton: UIButton!
    
    @IBOutlet var acceptORRejectLabel: UILabel!
    
    @IBOutlet var acceptORRejectView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        BasicFunctions.setRoundCornerOfImageView(imageView: self.profileImageView)
        
        BasicFunctions.setBorderOfView(view: self.mainView)
        
        BasicFunctions.setRoundCornerOfButton(button: self.startNavigationButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.acceptButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.rejectButton, radius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
