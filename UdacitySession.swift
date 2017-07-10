import Foundation
import UIKit

// MARK: - udacityLogin with ID/PW
func udacityLogin(id: String, pw: String, completionHandler: @escaping (_ success: Bool, _ errorMessage: String?) -> Void ) {
    let appDelegate: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    
    // MARK: #1 Make USER INFO to JSON & make Request
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    let dictionaryValues = [
        "udacity" : [
            "username" : id,
            "password" : pw,
        ]
    ]
    var userInfo: Data? = nil
    do{
        userInfo = try JSONSerialization.data(withJSONObject: dictionaryValues, options: JSONSerialization.WritingOptions.prettyPrinted)
    } catch{
        
    }
    
    //MARK: #2 Make Post Request

    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = userInfo
    
    //MARK: #3 GET Session Auth from UDACITY
    taskWithRequestToUDACITY(request as URLRequest){ result, error in
        if error == nil {
            if let account = result!.value(forKey: "account") as? NSDictionary {
                if let sessionKey = account.value(forKey: "key") as? String {
                    appDelegate.sessionKey = sessionKey
                    
                    //MARK: #4 Complete udacityLogin with sessionKey
                    completeLogin( sessionKey ) { success, errorMessage in
                        if( success ) {
                            print( "Login Success" )
                            completionHandler(true, nil)
                        } else {
                            completionHandler(false, error?.localizedDescription)
                        }
                    }
                } else {
                    completionHandler(false, error?.localizedDescription)
                }
            } else {
                completionHandler(false, error?.localizedDescription)
            }
        } else {
            completionHandler(false, error?.localizedDescription)

        }
    }
}

// MARK: - Getting Session Key with ID / PW
private func taskWithRequestToUDACITY( _ request: URLRequest, completionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
        if error == nil {
            guard let data = data else {
                return
            }
            
            let range = Range(5 ..< data.count)
            let tempData = data.subdata(in: range) /* subset response data! */
            
            //Raw JASON to JSON
            let rawData = NSString(data: tempData, encoding: String.Encoding.utf8.rawValue)!
            
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

// MARK: - Complete udacityLogin with sessionKey
private func completeLogin(_ sessionKey:String, completionHandler: @escaping (_ success: Bool, _ errorMessage: String?) -> Void ) {

    let appDelegate: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(sessionKey)")!)
    
    taskWithRequestToUDACITY(request as URLRequest){result, error in
        if error == nil {
            if let NewData = result!["user"] as? [String : Any] {
                //store User info
                appDelegate.userData.lastName = NewData["last_name"] as! String
                appDelegate.userData.firstName = NewData["first_name"] as! String
                appDelegate.userData.uniqueKey = sessionKey
                
                completionHandler(true, nil)
            } else {
                completionHandler(false, error?.localizedDescription)
            }
        } else {
            completionHandler(false, error?.localizedDescription)
        }
    }
}



func logOut() {
    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    
 //   let LogOutQueue = DispatchQueue(label: "LogOut", attributes: [])
    
 //   LogOutQueue.async{ () -> Void in
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
  //  }
}
