//
//  Globals.swift
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import Foundation
import Contacts
import CoreLocation


var kContactList = [ContactData]()
var kUserList = [UserList]()
var kCurrentLocation : CLLocationCoordinate2D?

var kImage : UIImage?
var kIsImageDeleted : Bool!
var kSelectedLocation : CLLocationCoordinate2D?
var kSelectedAddress : String?
var kNotificationData : [String : Any]?

let kIfUserLoggedIn = "isUserLoggedIn"
let kUserID = "userID"
let kAccessToken = "accessToken"
let kFirstName = "firstName"
let kLastName = "lastName"
let kGender = "gender"
let kEmail = "email"
let kImageURL = "imageURL"
let kDOB = "dob"
let kDOR = "dor"
let kCreatedAt = "createdAt"
let kUpdatedAt = "updatedAt"
let kCancelInfo = "All users who accepted this message will get the notification that the message has been cancelled."
let kDeleteInfo = "All users who have not rejected this message will get the notification that the message has been deleted."
let kDeviceToken = "DeviceToken"
let kUserProfile = "UserProfile"
var kLoggedInUserProfile = NSKeyedUnarchiver.unarchiveObject(with: BasicFunctions.getPreferences(kUserProfile) as! Data) as! UserProfile

var kBirthdayMessage = "It is highly recommended that you provide “Date of Birth” for getting exclusive special discounts, or even completely free “Birthday Presents” from top brands ;and free “Dining Offers” from some of the best restaurants in your city on your special day. Go to “PROFILE” in the menu and update now."

#if DEVELOPMENT
var kBaseURL = "http://dev.invited.shayansolutions.com/"
#else
var kBaseURL = ""
#endif

let kConfigURL = "http://invited.shayansolutions.com/"
