//
//  PresentImageViewController.swift
//  Snap Photo
//
//  Created by Yassine on 27/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import UIKit

class PresentImageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var LinkData = ""
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        if LinkData != nil {
            imageView.image = UIImage(named: LinkData)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PresentImageViewController.tap(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
    }
    func tap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
   
    func presentActivityController(LinkData : String) {
        let imageFromURL = UIImage(named: LinkData)
        if let img = imageFromURL {
            let imageToShare = [ img ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    // CLOSE BUTTON
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // SAVE BUTTON
    @IBAction func getImageButton(_ sender: UIButton) {
        presentActivityController(LinkData: LinkData)
    }
}


