//
//  SentByMeView.swift
//  Invited
//
//  Created by ShayanSolutions on 7/10/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class SentByMeView: UIView {
    
    @IBOutlet var createEventDate: UILabel!
    
    @IBOutlet var numberOfInvitationAccepted: UILabel!
    
    @IBOutlet var acceptedUserTableView: UITableView!
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var sendReportButton: UIButton!
    
    @IBOutlet var sendReportViewHeightConstraint: NSLayoutConstraint!
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instanceFromNib() -> UIView {
        
        
        return UINib(nibName: "SentByMeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
