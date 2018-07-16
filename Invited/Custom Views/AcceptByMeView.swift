//
//  AcceptByMeView.swift
//  Invited
//
//  Created by ShayanSolutions on 7/9/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class AcceptByMeView: UIView {
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var invitedBy: UILabel!
    
    @IBOutlet var eventDate: UILabel!
    
    @IBOutlet var totalInvited: UILabel!
    
    @IBOutlet var eventReceivedDate: UILabel!
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet var startNavigationButton: UIButton!
    
    
    
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instanceFromNib() -> UIView {
        
        
        return UINib(nibName: "AcceptByMeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
