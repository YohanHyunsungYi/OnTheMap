//
//  serchMapViewController.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 7..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet var searchMapKit: MKMapView!
    @IBOutlet var activutyIndicator: UIActivityIndicatorView!
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var updateOrNew: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activutyIndicator.startAnimating()
        activutyIndicator.hidesWhenStopped = true
        
        searchMapKit.showsUserLocation = true
        searchMapKit.delegate = self
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userData = appDelegate.userData
        print(userData)
        performSearch(searchLocation: userData.locationName)
    }
    
    func performSearch(searchLocation:String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchLocation as String
        request.region = searchMapKit.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                let alertController = UIAlertController(title: "ERROR", message: "Try Again!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.activutyIndicator.stopAnimating()
                return
            }
            
            if response.mapItems.count == 0 {
                let alertController = UIAlertController(title: "no Matches Found", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.activutyIndicator.stopAnimating()
            }else {
                let item = response.mapItems[0]
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.appDelegate.userData.latitude = item.placemark.coordinate.latitude
                self.appDelegate.userData.longitude = item.placemark.coordinate.longitude
                
                let span = MKCoordinateSpanMake(5, 5)
                let region = MKCoordinateRegion(center: annotation.coordinate, span:span)
                self.searchMapKit.setRegion(region, animated: true)
                self.searchMapKit.addAnnotation(annotation)
            }
            self.activutyIndicator.stopAnimating()
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if updateOrNew {
            let updateQueue = DispatchQueue(label: "update", attributes: [])
            updateQueue.async{ () -> Void in
                updatePin(urlString: "https://parse.udacity.com/parse/classes/StudentLocation/\(self.appDelegate.pinObjectID)"){ result , error in
                    if result == true {
                        getStudentLocation(){result, error in
                            if error == nil{
                                DispatchQueue.main.async(execute: {
                                    //go to tabBarView
                                    self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarController"))!, animated: true, completion: nil)
                                })
                            }
                        }
                    } else {
                        DispatchQueue.main.async(execute: {
                            //ERROR
                            let alertController = UIAlertController(title: "Add Location Fail", message: error, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                }
            }
            
        } else {
            let addQueue = DispatchQueue(label: "add", attributes: [])
            addQueue.async{ () -> Void in
                postPin(urlString: "https://parse.udacity.com/parse/classes/StudentLocation"){ result , error in
                    if result == true {
                        getStudentLocation(){result, error in
                            if error == nil{
                                DispatchQueue.main.async(execute: {
                                    //go to tabBarView
                                    self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarController"))!, animated: true, completion: nil)
                                })
                            }
                        }
                    } else {
                        DispatchQueue.main.async(execute: {
                            //ERROR
                            let alertController = UIAlertController(title: "Add Location Fail", message: error, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        })
                        
                    }
                }
            }
        }
    }
}

    
    
    
    
    
    
    
    
    
  
