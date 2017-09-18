//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Yohan Yi on 2017. 6. 4..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var MapView: MKMapView!
    
    var aplicationDelegate: AppDelegate!
    let locationManager = CLLocation()
    var annotations = [MKAnnotation]()
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        activity.hidesWhenStopped = true
        aplicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        updatePins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updatePins()
    }
    
    func updatePins() {
        //MARK: delete all pins
        let allAnotations = self.MapView.annotations
        self.MapView.removeAnnotations(allAnotations)
        annotations = []
        
        //MARK: Set Region
        let span = MKCoordinateSpanMake(10, 10)
        let defaultLocation = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(34.0652),
            longitude: CLLocationDegrees(-118.303)
        )
        
        let region = MKCoordinateRegion(center: defaultLocation, span:span)
        MapView.setRegion(region, animated: true)
        
        //MARK: Start Activity Indicator
        activity.startAnimating()
        
        let LoginQueue = DispatchQueue(label: "Login", attributes: [])
        LoginQueue.async{ () -> Void in
            getStudentLocation(){result, error in
                if result {
                    DispatchQueue.main.async(execute: {
                        // Put anotations
                        // Store into Appdelegate's Pin
                        for tempPin in AppDelegate.StudentDataSource.sharedInstance.studentData{
                            
                            let pin = MKPointAnnotation()
                            pin.coordinate.latitude = tempPin.latitude!
                            pin.coordinate.longitude = tempPin.longitude!
                            pin.title = (tempPin.firstName! + tempPin.lastName!)
                            pin.subtitle = tempPin.mediaURL
                            
                            self.annotations.append(pin)
                        }
                        
                        self.MapView.addAnnotations(self.annotations)
                        
                        // Stop Activity Indicatior
                        self.activity.stopAnimating()
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        //Error - Download Pins From Udacity
                        let alertController = UIAlertController(title: "Error: Download Pins From Udacity", message: error, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:reuseId)
        annotationView.isEnabled = true
        annotationView.canShowCallout = true
        annotationView.tintColor = UIColor.blue
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = btn
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            if let url = URL(string: (annotationView.annotation?.subtitle as? String)!) {
                UIApplication.shared.open(url, options: [:]){ success in
                    if success {
                        
                    } else {
                        //Fail to Open
                        let alertController = UIAlertController(title: "Cannot open website", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        OnTheMap.logOut()
        self.dismiss(animated: true, completion: {})
    }
}


