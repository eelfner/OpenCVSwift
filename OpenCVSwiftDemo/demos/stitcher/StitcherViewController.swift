//
//  StitcherViewController.swift
//  OpenCVSwift
//
//  Created by Eric Elfner on 2016-03-24.
//  Copyright © 2016 Eric Elfner. All rights reserved.
//

// Notes on Main.storyboard StitcherViewController scene:
// - View Controller -> Adjust ScrollView Insets: DESELECT!
//  - View
//   - Top Layout Guide
//   - Bottom Layout Guide
//   - Scroll View -> Autolayout Pin to Top/Bottom Guides, View L/R
//   - Content View 
//       -> Autolayout Pin to ScrollView (sets content size) 
//       -> Align center X and Y (sets position)
//    - Stitched Image View -> Autolayout Pin to Content View
//

import UIKit
import OpenCVObjcFramework

class StitcherViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var stitchedImageView: UIImageView!
    
    private var stitchedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
    }

    // If no image has been set, do a stitch with built in images
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let stitchedImage = stitchedImage {
            stitchedImageView.image = stitchedImage
        }
        else {
            stitch()
        }
    }
    
    // Called from Segue
    func setImageForViewing(image:UIImage) {
        stitchedImage = image
    }
    
    private func stitch() {
        if let image1 = UIImage(named:"pano_19_16_mid.jpg"),
            let image2 = UIImage(named:"pano_19_20_mid.jpg"),
            let image3 = UIImage(named:"pano_19_22_mid.jpg"),
            let image4 = UIImage(named:"pano_19_25_mid.jpg") {
            
            self.activityIndicator.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let imageArray = [image1, image2, image3, image4]
                let stitchedImage = CVWrapper.stitchImages(imageArray)
                
                dispatch_async(dispatch_get_main_queue()) {
                    print("Created stichedImage \(stitchedImage)")
                    self.stitchedImageView.image = stitchedImage
                    self.setImageZoomForCurrentSize()
                    self.scrollView.delegate = self
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    private func setImageZoomForCurrentSize() {
        if let stitchedImage = self.stitchedImageView?.image {
            let scrollViewSize = self.scrollView.frame.size
            let scaleWidth = stitchedImage.size.width / scrollViewSize.width
            let scaleHeight = stitchedImage.size.height / scrollViewSize.height
            let scaleFullView = max(scaleWidth, scaleHeight)
            self.scrollView.maximumZoomScale = scaleFullView
            self.scrollView.minimumZoomScale = min(1.0, scaleFullView)
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale // Show all
        }
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.setImageZoomForCurrentSize() // Resize before rotation
        super.viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
        
        // Because the UIImage has View Mode = Aspect Fit we need to first resize to full size before rotation to get the image to resize.
        // Then resize again after rotation, to get the scroll view parameters correctly set. This could be optimized a bit.
        coordinator.animateAlongsideTransition(nil) { (_) in
            self.setImageZoomForCurrentSize() // Resize after rotation
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView:UIScrollView) -> UIView? {
        return stitchedImageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
    }
}
