//
//  ReceivedEventDetailView.swift
//  Invited
//
//  Created by ShayanSolutions on 6/13/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class ReceivedEventDetailView: UIView {
    
    @IBOutlet var receivedEventDetailTableView: UITableView!
    
    @IBOutlet var backButton: UIButton!
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instanceFromNib() -> UIView {
        
        
        return UINib(nibName: "ReceivedEventDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
