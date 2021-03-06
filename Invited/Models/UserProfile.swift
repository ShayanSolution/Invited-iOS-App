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
    var firstName : String?
    var lastName : String?
    var gender : Int?
    var email : String?
    var imageURL : String?
    var dob : String?
    var dor : String?
    var createdAt : String?
    var updatedAt : String?
    
    
    init(id: Int, accessToken : String, firstName : String, lastName : String, gender : Int, email : String, imageURL : String, dob : String, dor : String, createdAt : String, updatedAt : String) {
        self.userID = id
        self.accessToken = accessToken
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.email = email
        self.imageURL = imageURL
        self.dob = dob
        self.dor = dor
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let userSpecificID = aDecoder.decodeObject(forKey: kUserID) as? Int ?? 0
        let token = aDecoder.decodeObject(forKey: kAccessToken) as? String ?? ""
        let firstName = aDecoder.decodeObject(forKey: kFirstName) as? String ?? ""
        let lastName = aDecoder.decodeObject(forKey: kLastName) as? String ?? ""
        let gender = aDecoder.decodeObject(forKey: kGender) as? Int ?? 0
        let email = aDecoder.decodeObject(forKey: kEmail) as? String ?? ""
        let imageURL = aDecoder.decodeObject(forKey: kImageURL) as? String ?? ""
        let dob = aDecoder.decodeObject(forKey: kDOB) as? String ?? ""
        let dor = aDecoder.decodeObject(forKey: kDOR) as? String ?? ""
        let createdAt = aDecoder.decodeObject(forKey: kCreatedAt) as? String ?? ""
        let updatedAt = aDecoder.decodeObject(forKey: kUpdatedAt) as? String ?? ""
        
        self.init(id: userSpecificID, accessToken: token, firstName: firstName, lastName: lastName, gender: gender, email: email, imageURL : imageURL, dob: dob, dor: dor, createdAt: createdAt, updatedAt: updatedAt)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: kUserID)
        aCoder.encode(self.accessToken, forKey: kAccessToken)
        aCoder.encode(self.firstName, forKey: kFirstName)
        aCoder.encode(self.lastName, forKey: kLastName)
        aCoder.encode(self.gender, forKey: kGender)
        aCoder.encode(self.email, forKey: kEmail)
        aCoder.encode(self.imageURL, forKey: kImageURL)
        aCoder.encode(self.dob, forKey: kDOB)
        aCoder.encode(self.dor, forKey: kDOR)
        aCoder.encode(self.createdAt, forKey: kCreatedAt)
        aCoder.encode(self.updatedAt, forKey: kUpdatedAt)
        
        
    }

}
