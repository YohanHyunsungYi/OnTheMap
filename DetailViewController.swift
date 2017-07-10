import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var location: UITextField!
    @IBOutlet var inputURL: UITextField!
    var PinList = AppDelegate.StudentDataSource.sharedInstance.studentData
    var userData = (UIApplication.shared.delegate as! AppDelegate).userData
    var updateOrNew = false
    var check = false
    
    @IBAction func FindLocation(_ sender: Any) {
        if location.text!.isEmpty || inputURL.text!.isEmpty {
            let alertController = UIAlertController(title: "Location or URL is empty", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        for temp in PinList{
            if temp.uniqueKey == userData.uniqueKey {
                check = true
                (UIApplication.shared.delegate as! AppDelegate).pinObjectID = temp.objectID
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
            userData.locationName = location.text!
            userData.locationName = inputURL.text!
            self.performSegue(withIdentifier: "searchMapViewSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let updateOrNew2 = segue.destination as! SearchMapViewController
        updateOrNew2.updateOrNew = self.check
    }
}
