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

class CustomPointAnnotation: MKPointAnnotation {
  var imageName: String!
  var imageSource: UIImage?
}

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
    let location = CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
        var title = ""
        if error == nil {
          var name: String = ""
          
          if let pm = placemarks?[0] {
            if pm.name != nil {
              name = (pm.name)!
            }
          }
          title = name
          
        }
      let annotation = MKPointAnnotation()
      annotation.coordinate = locationCoordinate
      
      annotation.title = title
      
      self.map.addAnnotation(annotation)
     
    } 
  }
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if !(annotation is  MKPointAnnotation) {
      return nil
    }
    
    let reuseID = "myAnnotationView"
    
    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
    if (annotationView == nil) {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
      let imageView = annotationView!.leftCalloutAccessoryView as! UIImageView
      imageView.image = self.photo
    }
    else {
      annotationView!.annotation = annotation
    }
    
    return annotationView
  }
  
}
