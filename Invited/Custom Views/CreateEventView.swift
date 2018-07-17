//
//  CreateEventView.swift
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class CreateEventView: UIView {
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var timeTextField: UITextField!
    
    @IBOutlet var dateTextField: UITextField!
    
    @IBOutlet var locationTextField: UITextField!
    
    @IBOutlet var iWillPayButton: UIButton!
    
    @IBOutlet var youWillPayButton: UIButton!
    
    @IBOutlet var allButton: UIButton!
    
    @IBOutlet var createButton: UIButton!
    
    @IBOutlet var createButtonView: UIView!
    
    @IBOutlet var setListTextField: UITextField!
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var updateButton: UIButton!
    
    @IBOutlet var updateButtonView: UIView!
    
    @IBOutlet var setNumberOfPeopleTextfield: UITextField!
    
    
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instanceFromNib() -> UIView {
        
        
        return UINib(nibName: "CreateEventView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
