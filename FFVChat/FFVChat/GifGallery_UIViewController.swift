//
//  GifGallery_UIViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class GifGallery_UIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIWebViewDelegate
{
    var collectionView : UICollectionView!
    
    var navBar : UIView!
    
    var backButton : UIButton!
    
    var gifs : [String]!
    
    var progress : NVActivityIndicatorView!
    
    weak var controller : Chat_ViewController!
    
    deinit
    {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        self.collectionView = nil
        self.navBar = nil
        self.backButton = nil
        self.gifs = nil
        self.progress = nil
    }
    
    init(controller : Chat_ViewController)
    {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        
        
        self.navBar = UIView(frame: CGRectMake(0,0,screenWidth, 70))
        self.navBar.backgroundColor = oficialDarkGray
        self.view.addSubview(self.navBar)
        
        self.backButton = UIButton(frame: CGRectMake(0,20, 50, 50))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: screenWidth/3 - 5)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 70, screenWidth, screenHeight - 70) , collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(FTNCollectionWebCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.collectionView)
        
        self.progress = NVActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100), type: NVActivityIndicatorType.BallPulse, color: oficialLightGray)
        self.progress.center = CGPointMake(screenWidth/2, screenHeight/2 - 100)
        self.progress.startAnimation()
        
        self.collectionView.addSubview(self.progress)

        self.gifs = [String]()
        
        DAOPostgres.sharedInstance.getAllGifsName({ (gifs) -> Void in
            
            self.gifs = gifs
            self.collectionView.reloadData()
            
            self.progress.removeFromSuperview()

        })
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload", name: NotificationController.center.gifDownloaded.name, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(NotificationController.center.gifDownloaded)
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func back()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reload()
    {
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.gifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FTNCollectionWebCell
        cell.backgroundColor = oficialDarkGray
        cell.clipsToBounds = true
        cell.webView.stopLoading()
        cell.webView.loadRequest(NSURLRequest(URL: NSURL(string: DAOContents.sharedInstance.getUrlFromGifName(self.gifs[indexPath.item]))!))
        cell.webView.contentScaleFactor = 2
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let attributes : UICollectionViewLayoutAttributes = self.collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!
        let frame = attributes.frame
        
        let origin = self.collectionView!.convertRect(frame, toView: self.collectionView!.superview)
        let gif = self.gifs[indexPath.row]
        
        let sharing = GifSharing_View(imageOrigin: origin, gifName: gif, controller: self)
        self.view.addSubview(sharing)
        
        sharing.animateOn()
        
    }
//    
//    func webViewDidFinishLoad(webView: UIWebView)
//    {
//        webView.scrollView.zoomScale += 0.5
//    }
    
//    func webViewResizeToContent(webView: UIWebView) {
//        webView.layoutSubviews()
//        
//        // Set to smallest rect value
//        var frame:CGRect = webView.frame
//        frame.size.height = 1.0
//        webView.frame = frame
//        
//        var height:CGFloat = webView.scrollView.contentSize.height
//        print("UIWebView.height: \(height)")
//        
//        
////        webView.setHeight(height: height)
//        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: height)
//        webView.addConstraint(heightConstraint)
//        
//        // Set layout flag
//        webView.window?.setNeedsUpdateConstraints()
//        webView.window?.setNeedsLayout()
//    }

}
