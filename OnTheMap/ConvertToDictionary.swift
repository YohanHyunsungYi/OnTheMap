//
//  ConvertToDictionary.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 5..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

func converToDictionary(_ text: String) -> [String:Any]?{
    if let data = text.data(using: .utf8){
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch {
            print("ConvertToDictionary Error: " + error.localizedDescription)
        }
    }
    return nil
}
