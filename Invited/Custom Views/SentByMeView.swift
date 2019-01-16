//
//  SentByMeView.swift
//  Invited
//
//  Created by ShayanSolutions on 7/10/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class SentByMeView: UIView {
    
    @IBOutlet var eventName: UITextView!
    
    @IBOutlet var listName: UILabel!
    
    @IBOutlet var yesCount: UILabel!
    
    @IBOutlet var noCount: UILabel!
    
    @IBOutlet var createEventDate: UILabel!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var location: UILabel!
    
    
    
    @IBOutlet var acceptedUserTableView: UITableView!
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var sendReportButton: UIButton!
    
    @IBOutlet var sendReportViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var dateViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var locationViewHeightConstraint: NSLayoutConstraint!
    
    
    
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
