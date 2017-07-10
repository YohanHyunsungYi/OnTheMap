import Foundation
import UIKit

func getStudentLocation( completionHandler: @escaping (_ success: Bool, _ errorMessage: String?) -> Void ) {
    
    AppDelegate.StudentDataSource.sharedInstance.studentData.removeAll()
    
    //Make Request
    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&skip=400&order=-updatedAt")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    taskWithRequest(request  as URLRequest){result , error in
        if error == nil{
            //store Pin Lists to APPDELEGATE
            guard let newPinDictionary = result!["results"] as! NSArray {
            
              for index in newPinDictionary {
                  var tempPin = PinList()
                  let tempDictionary = index as! NSDictionary
                  for (key2, value2) in tempDictionary {
                      if key2 as! String == "createdAt" { tempPin.createdAt = value2 as! String }
                      if key2 as! String == "firstName" { tempPin.firstName = value2 as! String }
                      if key2 as! String == "lastName" { tempPin.lastName = value2 as! String }
                      if key2 as! String == "latitude" { tempPin.latitude = value2 as! Double }
                      if key2 as! String == "longitude" { tempPin.longitude = value2 as! Double }
                      if key2 as! String == "mapString" { tempPin.mapString = value2 as! String }
                      if key2 as! String == "objectID" { tempPin.objectID = value2 as! String }
                      if key2 as! String == "uniqueKey" { tempPin.uniqueKey = value2 as! String }
                      if key2 as! String == "updatedAt" { tempPin.updatedAt = value2 as! String }
                      if key2 as! String == "mediaURL" {
                          if let tempURL = value2 as? String { tempPin.mediaURL = tempURL }
                      }
                  }
                  AppDelegate.StudentDataSource.sharedInstance.studentData.append(tempPin)
                  completionHandler(true, nil)
              }
            } else {
              completionHandler(false, error?.localizedDescription) 
            }
        } else {
            completionHandler(false, error?.localizedDescription)
        }
    }
}

private func taskWithRequest( _ request: URLRequest, completionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
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
            completionHandler(newData as AnyObject, nil)
            
        }else {
            //Error
            completionHandler(response, error as NSError?)
        }
    })
    task.resume()
    return task
}
