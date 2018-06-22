//
//  YourEventsCell.swift
//  Invited
//
//  Created by ShayanSolutions on 6/1/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class YourEventsCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet var totalInvited: UILabel!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var expandButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        BasicFunctions.setRoundCornerOfButton(button: self.editButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.deleteButton, radius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
