//
//  ImageViewController.swift
//  Photo Map
//
//  Created by Dan Tong on 9/25/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
  
  @IBOutlet weak var fullImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fullImageView.image = selectedImage
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func backToMap(sender: UIButton) {
      self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
