//
//  WelcomeVC.swift
//  Invited
//
//  Created by ShayanSolutions on 5/21/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    
    @IBOutlet var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews()
    {
        BasicFunctions.setRoundCornerOfView(view: self.loginView, radius: 5.0)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SignUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        
        if sender.tag == 1
        {
            vc.isLoginPage = true
        }
        else
        {
            vc.isLoginPage = false
        }
        
        BasicFunctions.pushVCinNCwithObject(vc: vc, popTop: true)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
