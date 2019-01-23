//
//  DetailView.swift
//  Invited
//
//  Created by ShayanSolutions on 6/2/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var createdBy: UILabel!
    
    @IBOutlet var titleTextView: UITextView!
    
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var createdDate: UILabel!
    
    
    @IBOutlet var location: UILabel!
    
    @IBOutlet var acceptORRejectButtonView: UIView!
    
    @IBOutlet var acceptButton: UIButton!
    
    @IBOutlet var rejectButton: UIButton!
    
    @IBOutlet var startNavigationView: UIView!
    
    @IBOutlet var startNavigationButton: UIButton!
    
    @IBOutlet var rejectLabel: UILabel!
    
    @IBOutlet var dateViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var locationViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var startNavigationViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var profileImageView: AsyncImageView!
    
    
    @IBOutlet var paymentMethodLabel: UILabel!
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instanceFromNib() -> UIView {
        
        
        return UINib(nibName: "DetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
