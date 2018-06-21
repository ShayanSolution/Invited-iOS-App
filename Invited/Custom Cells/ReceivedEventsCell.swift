//
//  ReceivedEventsCell.swift
//  Invited
//
//  Created by ShayanSolutions on 6/1/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class ReceivedEventsCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var invitedBy: UILabel!
    
    
    @IBOutlet var iconAccepted: UIImageView!
    
    @IBOutlet var acceptLabel: UILabel!
    
    @IBOutlet var expandButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
