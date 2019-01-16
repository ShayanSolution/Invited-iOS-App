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
let kSelectedAddress = "selectedAddress"
let kSelectedLat = "selectedLat"
let kSelectedLong = "selectedLong"
let kIfUserLoggedIn = "isUserLoggedIn"
let kUserID = "userID"
let kAccessToken = "accessToken"
let kFirstName = "firstName"
let kLastName = "lastName"
let kEmail = "email"
let kDOB = "dob"
let kDOR = "dor"
let kCreatedAt = "createdAt"
let kUpdatedAt = "updatedAt"
let kCancelInfo = "All users who accepted this message will get the notification that the message has been cancelled."
let kDeleteInfo = "All users who have not rejected this message will get the notification that the message has been deleted."
let kDeviceToken = "DeviceToken"
let kUserProfile = "UserProfile"
var kLoggedInUserProfile = NSKeyedUnarchiver.unarchiveObject(with: BasicFunctions.getPreferences(kUserProfile) as! Data) as! UserProfile

#if DEVELOPMENT
var kBaseURL = "http://dev.invited.shayansolutions.com/"
#else
var kBaseURL = ""
#endif

let kConfigURL = "http://invited.shayansolutions.com/"
