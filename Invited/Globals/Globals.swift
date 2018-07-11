//
//  Globals.swift
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import Foundation
import Contacts


var kContactList = [ContactData]()
var kUserList = [UserList]()
let kSelectedAddress = "selectedAddress"
let kSelectedLat = "selectedLat"
let kSelectedLong = "selectedLong"
let kIfUserLoggedIn = "isUserLoggedIn"
let kUserID = "userID"
let kAccessToken = "accessToken"
let kDeviceToken = "DeviceToken"
let kUserProfile = "UserProfile"
let kLoggedInUserProfile = NSKeyedUnarchiver.unarchiveObject(with: BasicFunctions.getPreferences(kUserProfile) as! Data) as! UserProfile
