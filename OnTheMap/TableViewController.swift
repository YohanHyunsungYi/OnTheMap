//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 4..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.StudentDataSource.sharedInstance.studentData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")!
        
        let pin = AppDelegate.StudentDataSource.sharedInstance.studentData[indexPath.row]
        // Set the name and image
        cell.textLabel?.text = pin.firstName! + " " + pin.lastName!
        cell.imageView?.image = UIImage(named: "pin.pdf")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pin = AppDelegate.StudentDataSource.sharedInstance.studentData[indexPath.row]
        let url = URL(string: pin.mediaURL!)
        
        UIApplication.shared.open(url!, options: [:]){ success in
            if success {
                
            } else {
                //Fail to Open
                let alertController = UIAlertController(title: "Cannot open website", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        OnTheMap.logOut()
        self.dismiss(animated: true, completion: {})
    }
}

