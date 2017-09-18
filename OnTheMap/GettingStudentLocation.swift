//
//  GETPinList.swift
//  onTheMap_Yohan
//
//  Created by Yohan Yi on 2017. 6. 12..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

func getStudentLocation( completionHandler: @escaping (_ success: Bool, _ errorMessage: String?) -> Void ) {
    
    AppDelegate.StudentDataSource.sharedInstance.studentData.removeAll()
    
    //Make Request
    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    taskWithRequest(request as URLRequest){success, result , error in
        if error == nil {
            //store Pin Lists to APPDELEGATE
            if let newPinDictionary = result?["results"] as? NSArray{
                for index in newPinDictionary {
                    let tempDictionary = index as! NSDictionary
                    
                    let tempPin = PinList(tempDictionary as! [String : Any])
                    
                    if tempPin.firstName != nil && tempPin.lastName != nil && tempPin.mediaURL != nil && tempPin.longitude != nil && tempPin.latitude != nil {
                        AppDelegate.StudentDataSource.sharedInstance.studentData.append(tempPin)
                    }
                }
                completionHandler(true, nil)
            }
        } else {
            completionHandler(false, error?.localizedDescription)
        }
    }
}

func taskWithRequest( _ request: URLRequest, completionHandler: @escaping (_ success: Bool, _ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
        if error == nil {
            guard let data = data else {
                return
            }
            
            //Raw JASON to JSON
            let rawData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            
            //JSON to Dictionary
            let newData = converToDictionary(rawData as String)
            
            //return data
            completionHandler(true, newData as AnyObject, nil)
            
        }else {
            //Error
            completionHandler(false, response, error as NSError?)
        }
    })
    task.resume()
    return task
}
