//
//  pinList.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 5..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

struct PinList {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectID: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(_ tempDictionary:[String:Any]) {
        
        self.createdAt = (tempDictionary["createdAt"] as? String)
        self.firstName = (tempDictionary["firstName"] as? String)
        self.lastName = (tempDictionary["lastName"] as? String)
        self.latitude = (tempDictionary["latitude"] as? Double)
        self.longitude = (tempDictionary["longitude"] as? Double)
        self.mapString = tempDictionary["mapString"] as? String
        self.mediaURL = tempDictionary["mediaURL"] as? String
        self.objectID = tempDictionary["objectId"] as? String
        self.uniqueKey = tempDictionary["uniqueKey"] as? String
        self.updatedAt = tempDictionary["updatedAt"] as? String

    }
}
