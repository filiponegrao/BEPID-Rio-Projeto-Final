//
//  ImageViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 14/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController : UIViewController, UIScrollViewDelegate
{
    var image : UIImage!
    
    var imageView : UIImageView!
    
    var scrollView : UIScrollView!
    
    var close : UIButton!
    
    var blackScreen : UIView!
    
    init(image: UIImage)
    {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        
        self.imageView = UIImageView(image: self.image)
        self.imageView.frame.origin = CGPointMake(0, 0)
        
        self.blackScreen = UIView(frame: self.view.bounds)
        self.blackScreen.backgroundColor = UIColor.blackColor()
        self.blackScreen.alpha = 0.7
        self.view.addSubview(self.blackScreen)
        
        self.scrollView = UIScrollView(frame: self.blackScreen.frame)
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.delegate = self
        self.scrollView.addSubview(self.imageView)
        self.scrollView.contentSize = image.size

        self.view.addSubview(self.scrollView)
        
        self.close = UIButton(frame: CGRectMake(10,20, 44,44))
        self.close.setImage(UIImage(named: "close"), forState: .Normal)
        self.close.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.close)
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        centerScrollViewContents()
    }
    
    func centerScrollViewContents()
    {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }

    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        centerScrollViewContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}