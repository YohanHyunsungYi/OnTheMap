//
//  UserData.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 7..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

struct userDataStruct{
    var firstName: String
    var lastName: String
    var uniqueKey: String
    var objectID: String
    var locationName: String
    var usersURL: String?
    var latitude: Double
    var longitude: Double
    
    init(){
        firstName = ""
        lastName = ""
        uniqueKey = ""
        objectID = ""
        locationName = ""
        usersURL = ""
        latitude = 0.0
        longitude = 0.0
    }
}
