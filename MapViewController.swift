import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
  @IBOutlet var MapView: MKMapView!

  var aplicationDelegate: AppDelegate!
  let locationManager = CLLocation()
  //MARK: Add Activity Indicator & Stop Animating
    
  override func viewDidLoad() {
    super.viewDidLoad()
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
        
    //MARK: Set Region
    let span = MKCoordinateSpanMake(10, 10)
    let defaultLocation = CLLocationCoordinate2D(
        latitude: CLLocationDegrees(34.0652),
        longitude: CLLocationDegrees(-118.303)
    )

    let region = MKCoordinateRegion(center: defaultLocation, span:span)
    MapView.setRegion(region, animated: true)
        
    //MARK: Start Activity Indicator
    let LoginQueue = DispatchQueue(label: "Login", attributes: [])
    LoginQueue.async{ () -> Void in
      getStudentLocation(){result, error in
        if error == nil{
          DispatchQueue.main.async(execute: {
            // Put anotations
            // Store into Appdelegate's Pin
            for tempPin in AppDelegate.StudentDataSource.sharedInstance.studentData{
              Pin(pinslatitude:tempPin.latitude, pinsLongitude:tempPin.longitude, pinsTitle:(tempPin.firstName + tempPin.lastName), pinsSubTitle:tempPin.mediaURL)
            } 
            
            // Stop Activity Indicatior              
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
  
  func Pin (pinslatitude:Double, pinsLongitude:Double, pinsTitle:String, pinsSubTitle:String) {
    let location = CLLocationCoordinate2D(
        latitude: CLLocationDegrees(pinslatitude),
        longitude: CLLocationDegrees(pinsLongitude)
    )
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
    annotation.title = pinsTitle
    annotation.subtitle = pinsSubTitle
    MapView.addAnnotation(annotation)
  }
  
  @IBAction func logOut(_ sender: Any) {
    OnTheMap.logOut()
      self.present((self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))!, animated: true, completion: nil)
    }
}
