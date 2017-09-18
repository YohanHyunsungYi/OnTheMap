//
//  DetailViewContoller.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 4..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var location: UITextField!
    @IBOutlet var inputURL: UITextField!
    var PinList = AppDelegate.StudentDataSource.sharedInstance.studentData
    var appDelgate = (UIApplication.shared.delegate as! AppDelegate)
    var updateOrNew = false
    var check = false
    
    @IBAction func FindLocation(_ sender: Any) {
        if location.text!.isEmpty || inputURL.text!.isEmpty {
            let alertController = UIAlertController(title: "Location or URL is empty", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        for temp in PinList {
            
            if temp.uniqueKey == appDelgate.userData.uniqueKey {
                check = true
                appDelgate.pinObjectID = temp.objectID!
            }
        }
        
        if check {
            let alertController = UIAlertController(title: "You Has Already Posted a Student Location", message: "Would You Like to Overwrite Your Location?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.updateOrNew = true
                (UIApplication.shared.delegate as! AppDelegate).userData.locationName = self.location.text!
                (UIApplication.shared.delegate as! AppDelegate).userData.usersURL = self.inputURL.text!
                
                self.performSegue(withIdentifier: "searchMapViewSegue", sender: self)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            appDelgate.userData.locationName = location.text!
            print(appDelgate.userData)
            appDelgate.userData.usersURL = inputURL.text!
            print(appDelgate.userData)
            self.performSegue(withIdentifier: "searchMapViewSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let updateOrNew2 = segue.destination as! SearchMapViewController
        updateOrNew2.updateOrNew = self.check
    }
}


