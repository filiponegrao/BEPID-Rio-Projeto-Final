//
//  Filters_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 01/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Filters_ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var topBar : UIView!
    
    var backButton : UIButton!
    
    var imageView : UIImageView!
    
    var collectionView : UICollectionView!
    
    var selectionBar : UIView!
    
    var doneButton : MKButton!
    
    //Dados a enviar
    
    var contact: Contact!
    
    var lifeTime : Int!
    
    var image : UIImage!
    
    //Dados
    
    var filtros = ["No Filter", "Circle", "Spark"]
    
    var selectedFilter : ImageFilter = ImageFilter.None
    
    //Efeitos
    
    var circleBlur : UIVisualEffectView!
    
    var circleUnblur : UIImageView!
    
    var sparkBlur : UIVisualEffectView!
    
    var contador : NSTimer!
    
    var warning : NSTimer!
    
    var lifespan : SelectedMidia_ViewController!
    
    init(image: UIImage, lifeTime: Int, contact: Contact)
    {
        self.image = image
        self.lifeTime = lifeTime
        self.contact = contact
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGray
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight*2/3))
        self.imageView.image = image
        self.imageView.clipsToBounds = true
//        self.imageView.contentMode = .ScaleAspectFill
        self.view.addSubview(self.imageView)
        
        self.topBar = UIView(frame: CGRectMake(0, 0, screenWidth, 70))
        self.topBar.backgroundColor = UIColor.blackColor()
        self.topBar.alpha = 0.5
        self.view.addSubview(self.topBar)
        
        self.backButton = UIButton(frame: CGRectMake(0,20, 50,50))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.backButton)
        
        
        self.doneButton = MKButton(frame: CGRectMake(0, screenHeight - 50, screenWidth, 50))
        self.doneButton.backgroundColor = oficialGreen
        self.doneButton.setTitle("Done", forState: .Normal)
        self.doneButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.doneButton.setTitleColor(oficialMediumGray, forState: .Highlighted)
        self.doneButton.addTarget(self, action: "done", forControlEvents: .TouchUpInside)
        self.doneButton.backgroundLayerCornerRadius = 900
        self.doneButton.rippleLocation = .Center
        self.doneButton.ripplePercent = 4
        self.doneButton.rippleLayerColor = oficialDarkGray
        self.view.addSubview(self.doneButton)
        
        let margem : CGFloat = 20
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: screenHeight/3 - self.doneButton.frame.size.height - margem)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5 //espaçamento entre uma celula de baixo com a de cima
        layout.scrollDirection = .Horizontal
        layout.headerReferenceSize = CGSizeMake(0, 0)
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, screenHeight*2/3 + margem, screenWidth, screenHeight/3 - self.doneButton.frame.size.height - margem), collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.registerClass(CellFilter_CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
        
        let lineHeight : CGFloat = 5
        
        self.selectionBar = UIView(frame: CGRectMake(10, self.collectionView.frame.origin.y - 2*lineHeight, screenWidth/3 - 20, lineHeight))
        self.selectionBar.backgroundColor = oficialGreen
        self.view.addSubview(self.selectionBar)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.filtros.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CellFilter_CollectionViewCell
        
        cell.imageView.image = self.image
        cell.title.text = self.filtros[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        A SER USADO NO FUTURO
        
//        let attributes : UICollectionViewLayoutAttributes = self.collectionView!.layoutAttributesForItemAtIndexPath(indexPath)!
//        let frameOnCollection = attributes.frame
//        
//        let frame = self.collectionView!.convertRect(frameOnCollection, toView: self.collectionView!.superview)
        
        switch indexPath.item
        {
            
        case 0:
            self.selectedFilter = ImageFilter.None
            self.selectionAnimating(0)
            self.removePreVisualizacaoCircle()
            self.removePreVisualizacaoSpark()
            
        case 1:
            self.selectedFilter = ImageFilter.Circle
            self.selectionAnimating(screenWidth/3)
            self.removePreVisualizacaoSpark()
            self.preVisualizacaoCircle()
            
        case 2:
            self.selectedFilter = ImageFilter.Spark
            self.selectionAnimating(screenWidth*2/3)
            self.removePreVisualizacaoCircle()
            self.preVisualizacaoSpark()
            
        default:
            print("indicie incorreto")
            
        }
        
        
    }
    
    //Tercos = terços, quantos terços deve percorree da tela
    func selectionAnimating(tercos: CGFloat)
    {
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: { () -> Void in
            
            self.selectionBar.frame.origin.x = tercos + 10
            
            }) { (success: Bool) -> Void in
                
                
        }
    }
    
    func preVisualizacaoCircle()
    {
        self.circleBlur?.removeFromSuperview()
        self.circleBlur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.circleBlur.frame = self.imageView.bounds
        self.imageView.addSubview(self.circleBlur)
        
        self.circleUnblur?.removeFromSuperview()
        self.circleUnblur = UIImageView(frame: CGRectMake(0, 0, diametro, diametro))
        self.circleUnblur.center = self.imageView.center
        self.circleUnblur.layer.cornerRadius = raio
//        self.circleUnblur.contentMode = .ScaleAspectFill
        self.circleUnblur.clipsToBounds = true
        self.circleUnblur.image = Editor.circleUnblur(self.image, x: self.circleUnblur.frame.origin.x, y: self.circleUnblur.frame.origin.y, imageFrame: self.imageView.frame)
        self.imageView.addSubview(self.circleUnblur)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.circleBlur.alpha = 1
        }
    }
    
    func removePreVisualizacaoCircle()
    {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.circleUnblur?.alpha = 0
            self.circleBlur?.alpha = 0
            }) { (success: Bool) -> Void in
                self.circleBlur?.removeFromSuperview()
                self.circleUnblur?.removeFromSuperview()
        }
    }
    
    func preVisualizacaoSpark()
    {
    
        self.sparkBlur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        self.sparkBlur.frame = self.imageView.bounds
        self.sparkBlur.alpha = 0
        self.sparkBlur?.removeFromSuperview()
        self.imageView.addSubview(self.sparkBlur)
        
        self.contador?.invalidate()
        self.contador = nil
        self.contador = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "changeAlpha", userInfo: nil, repeats: true)
        
        self.warning?.invalidate()
        self.warning = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "sparkWarning", userInfo: nil, repeats: false)

    }
    
    func changeAlpha()
    {
        if(self.sparkBlur.alpha == 0)
        {
            self.sparkBlur.alpha = 1
        }
        else
        {
            self.sparkBlur.alpha = 0
        }
    }
    
    func removePreVisualizacaoSpark()
    {
        self.warning?.invalidate()
        self.contador?.invalidate()
        self.contador = nil
        self.sparkBlur?.removeFromSuperview()
    }
    

    func sparkWarning()
    {
        self.removePreVisualizacaoSpark()
        let alert = UIAlertController(title: "Warning!", message: "Spark filter when used for a long time can be harmful for your health. Avoid stay looking for the image for a long and continuos time!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancel()
    {
        
        let nav = self.presentingViewController as! AppNavigationController
        let controller = nav.viewControllers.last
        
        if controller!.isKindOfClass(Chat_ViewController)
        {
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                let lifespan = SelectedMidia_ViewController(image: self.image, contact: self.contact)
                
                controller?.presentViewController(lifespan, animated: true, completion: { () -> Void in
                    
                })
                
            }
        }
        else if controller!.isKindOfClass(SentMidiaGallery_ViewController)
        {
            self.dismissViewControllerAnimated(true) { () -> Void in
                
                let lifespan = SelectedMidia_ViewController(image: self.image, contact: self.contact)
                
                controller?.presentViewController(lifespan, animated: true, completion: { () -> Void in
                    
                })
                
            }

        }

    }
    
    func done()
    {
        let nav = self.presentingViewController as! AppNavigationController
        let controller = nav.viewControllers.last
        
        if controller!.isKindOfClass(Chat_ViewController)
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                (controller as! Chat_ViewController).sendImage(self.image, lifetime: self.lifeTime, filter: self.selectedFilter)
                
            })
        }
        else if controller!.isKindOfClass(SentMidiaGallery_ViewController)
        {
            let chat = nav.viewControllers[1] as! Chat_ViewController
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                controller!.navigationController?.popViewControllerAnimated(true)
                
                chat.sendImage(self.image, lifetime: self.lifeTime, filter: self.selectedFilter)
            })
        }

    }
    
}




