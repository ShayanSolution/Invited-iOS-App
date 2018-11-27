//
//  YourEventsCell.swift
//  Invited
//
//  Created by ShayanSolutions on 6/1/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class YourEventsCell: UITableViewCell {
    
    @IBOutlet var title: UITextView!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet var totalInvited: UILabel!
    
    @IBOutlet var listName: UILabel!
    
    @IBOutlet var createdDate: UILabel!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var expandButton: UIButton!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var startNavigationButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        BasicFunctions.setBorderOfView(view: self.mainView)
        
        BasicFunctions.setRoundCornerOfButton(button: self.startNavigationButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.editButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.deleteButton, radius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
