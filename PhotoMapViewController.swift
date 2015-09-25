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

var selectedImage: UIImage?

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
  
  
  let vc = UIImagePickerController()
  var photo: UIImage?
  
  @IBOutlet weak var map: MKMapView!

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
    let editedImage = info[UIImagePickerControllerEditedImage]as! UIImage
    photo = editedImage
    selectedImage = photo
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
    map.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1)), animated: false)
  }
  
  // MARK: LocationsViewControllerDelegate protocol
  
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
    
    // MARK: Focus the map to the selected location
    
    let latDelta: CLLocationDegrees = 0.08
    let lonDelta: CLLocationDegrees = 0.08
    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
    let region: MKCoordinateRegion = MKCoordinateRegionMake(locationCoordinate, span)
    self.map.setRegion(region, animated: true)
  }
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    if control == view.rightCalloutAccessoryView {
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ImageView") as! ImageViewController
      self.presentViewController(vc, animated: true, completion: nil)
      
    }
  }
  
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if !(annotation is  MKPointAnnotation) {
      return nil
    }
    
    // Resize the image selected
    let resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
    resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
    resizeRenderImageView.layer.borderWidth = 3.0
    resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
    resizeRenderImageView.image = self.photo //(annotation as? PhotoAnnotation)?.photo
    
    UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
    resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let reuseID = "myAnnotationView"
    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
    if (annotationView == nil) {
      // Must use MKAnnotationView instead of MKPointAnnotationView if we want to use image for pin annotation
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.image = thumbnail
      // Left Image annotation
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:80))
      let imageView = annotationView!.leftCalloutAccessoryView as! UIImageView
      imageView.image = photo
      // Right button annotation
      annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIButton
    }
    else {
      annotationView!.annotation = annotation
    }
    
    return annotationView
  }
  
}
