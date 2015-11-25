//
//  AppNavigationController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 29/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit


class AppNavigationController : UINavigationController, UIViewControllerTransitioningDelegate
{
    init()
    {
        super.init(nibName: "AppNavigationController", bundle: nil)
    
        let flow = flowLayoutSetup()
        
        let collectView = ContactsBubble_CollectionViewController(collectionViewLayout: flow)
        
//        self.pushViewController(collectView, animated: false)
        self.viewControllers = [collectView]
        
        self.navigationBar.hidden = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    func flowLayoutSetup() -> UICollectionViewFlowLayout
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let dimension:CGFloat = self.view.frame.width * 0.23
        let labelHeight:CGFloat = 30
        flowLayout.itemSize = CGSize(width: dimension, height: dimension + labelHeight)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 10, right: 30)
        flowLayout.minimumLineSpacing = 20.0
        
        return flowLayout
    }
    
    //******* TRANSITIONS ********
}

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}

extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(self)
        navigationBarImageView!.hidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}