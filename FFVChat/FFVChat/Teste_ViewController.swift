////
////  Teste_ViewController.swift
////  FFVChat
////
////  Created by Fernanda Carvalho on 11/30/15.
////  Copyright © 2015 FilipoNegrao. All rights reserved.
////
//
//import UIKit
//
//class Teste_ViewController: CAPSPageMenu
//{
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        
//        let flow = flowLayoutSetup()
//        let collectView = ContactsBubble_CollectionViewController(collectionViewLayout: flow)
//        
//        self.pageMenu = CAPSPageMenu(viewControllers: [collectView], frame: CGRectMake(0, 80, screenWidth, 70), pageMenuOptions: nil)
//        
//        
//    }
//
//    override func didReceiveMemoryWarning()
//    {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func flowLayoutSetup() -> UICollectionViewFlowLayout
//    {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
//        
//        let dimension:CGFloat = self.view.frame.width * 0.23
//        let labelHeight:CGFloat = 30
//        flowLayout.itemSize = CGSize(width: dimension, height: dimension + labelHeight)
//        
//        flowLayout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 10, right: 30)
//        flowLayout.minimumLineSpacing = 20.0
//        
//        return flowLayout
//    }
//
//
//}
