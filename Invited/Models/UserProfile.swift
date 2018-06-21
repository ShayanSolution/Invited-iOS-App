//
//  UserProfile.swift
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit

class UserProfile: NSObject,NSCoding
{
    var userID : Int?
    var accessToken : String?
    
    
    init(id: Int, accessToken : String) {
        self.userID = id
        self.accessToken = accessToken
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let userSpecificID = aDecoder.decodeObject(forKey: kUserID) as? Int
        let token = aDecoder.decodeObject(forKey: kAccessToken) as? String
        
        self.init(id: userSpecificID! , accessToken: token!)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: kUserID)
        aCoder.encode(self.accessToken, forKey: kAccessToken)
        
        
    }

}
