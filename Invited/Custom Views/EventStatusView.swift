//
//  EventStatusView.swift
//  Invited
//
//  Created by ShayanSolutions on 5/29/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class EventStatusView: UIView {
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet var requestButton: UIButton!
    
    @IBOutlet var yourEventsButton: UIButton!
    
    @IBOutlet var receivedButton: UIButton!
    
    @IBOutlet var lineView: UIView!
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instanceFromNib() -> UIView {
        
        
        return UINib(nibName: "EventStatusView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
