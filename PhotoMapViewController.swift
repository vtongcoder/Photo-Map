//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Dan Tong on 9/24/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
  let vc = UIImagePickerController()
  
  
  
  @IBOutlet weak var map: MKMapView!
  var photo: UIImage?

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initMap()
  }
  
  @IBAction func cameraButton(sender: UIButton) {
    
    vc.delegate = self
    vc.allowsEditing = true
    
    vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    
    self.presentViewController(vc, animated: true, completion: nil)
    
    
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//    let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let editedImage = info[UIImagePickerControllerEditedImage]as! UIImage
    photo = editedImage    
    picker.dismissViewControllerAnimated(true) { () -> Void in
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LocationsViewController") as! LocationsViewController
      
      vc.delegate = self
      self.presentViewController(vc, animated: true, completion: nil)
    }

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func initMap() {
    // default location = San Fancisco
//    let latitue: CLLocationDegrees = 37.3298
//    let longitude: CLLocationDegrees = -121.9030
//    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitue, longitude)
//    let latDelta: CLLocationDegrees = 0.01
//    let lonDelta: CLLocationDegrees = 0.01
//    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
//    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
//    self.map.setRegion(region, animated: true)
    
    map.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
  }
  func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = locationCoordinate
    annotation.title = "Picture!"
    map.addAnnotation(annotation)
  }
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
