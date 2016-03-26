//
//  StitchUserPhotoViewController.swift
//  OpenCVObjcFramework
//
//  Created by Eric Elfner on 2016-03-25.
//  Copyright © 2016 Eric Elfner. All rights reserved.
//

import UIKit

class StitchUserPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageViewStitched: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    private var pickedImageViewTarget:UIImageView?
    
    // MARK: IBActions
    
    @IBAction func image1Tapped() {
        getImageFor(imageView1)
    }
    @IBAction func image2Tapped() {
        getImageFor(imageView2)
    }
    @IBAction func image3Tapped() {
        getImageFor(imageView3)
    }
    @IBAction func redoTapped() {
        tryStitch()
    }
    
    // MARK: 
    private func getImageFor(imageView:UIImageView) {
        pickedImageViewTarget = imageView
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated:true, completion:nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            image = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image = originalImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = image, let imageView = pickedImageViewTarget {
            imageView.image = image
            tryStitch()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    private func tryStitch() {
        if let image1 = imageView1.image,
            image2 = imageView2.image,
            image3 = imageView3.image {
            let images = [image1, image2, image3]
            
            self.activityIndicator.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let stitchedImage = CVWrapper.stitchImages(images)
                
                dispatch_async(dispatch_get_main_queue()) {
                    print("Created stichedImage \(stitchedImage)")
                    self.imageViewStitched.image = stitchedImage
                    self.activityIndicator.stopAnimating()
                }
            }
            
            
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "userStitchSegue" {
            let bHaveImage = imageViewStitched.image != nil
            return bHaveImage
        }
        else {
            return super.shouldPerformSegueWithIdentifier(identifier, sender:sender)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userStitchSegue" {
            if let vc = segue.destinationViewController as? StitcherViewController {
                if let image = imageViewStitched.image {
                    vc.setImageForViewing(image)
                }
            }
        }
    }
}
