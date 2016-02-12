//
//  CellGif_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 03/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellGif_TableViewCell: UITableViewCell, UIWebViewDelegate
{
    var cellView : UIView!
    
    var backgroundLabel : UIView!
    
    var gifView : UIGifView!

    var sentDate : UILabel!
    
    var indicator : NVActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame.size.height = screenWidth/6 * 2
        
        self.backgroundLabel = UIView(frame: CGRectMake(margemLateral, margemVertical, cellBackgroundWidth, cellBackgroundWidth))
        self.backgroundLabel.backgroundColor = UIColor.whiteColor()
        self.backgroundLabel.alpha = 0.1
        self.backgroundLabel.layer.cornerRadius = 10
        self.backgroundLabel.layer.zPosition = 0
        self.addSubview(self.backgroundLabel)
        
        self.cellView = UIView(frame: CGRectMake(0, 0, self.frame.size.height , self.frame.size.height))
        self.cellView.backgroundColor = UIColor.clearColor()
        self.addSubview(cellView)
        
        self.gifView = UIGifView(frame: CGRectMake(margemLateral+5, margemVertical+5, cellBackgroundWidth - 10, cellBackgroundWidth - dateTextHeigth*2 - 10))
        self.gifView.clipsToBounds = true
        self.gifView.layer.cornerRadius = 10
//        self.webView.contentMode = .ScaleAspectFill
        self.gifView.layer.zPosition = 5
        self.gifView.userInteractionEnabled = false
        self.cellView.addSubview(gifView)
        
        self.bringSubviewToFront(self.gifView)
        
        let h = Editor.heightForView("09:00", font: UIFont(name: "Gill Sans", size: 10)!, width: dateTextWidth)
        self.sentDate = UILabel(frame: CGRectMake(cellBackgroundWidth - dateTextWidth + margemLateral - 5, cellBackgroundWidth - dateTextHeigth - margemVertical, dateTextWidth, h))
        self.sentDate.text = "09:00"
        self.sentDate.font = UIFont(name: "Gill Sans", size: 10)
        self.sentDate.textAlignment = .Right
        self.sentDate.textColor = UIColor.whiteColor()
        self.cellView.addSubview(self.sentDate)
        
        
        self.indicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, self.gifView.frame.size.width/1.5, self.gifView.frame.size.height/1.5), type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen)
        self.indicator.center = self.gifView.center
        self.indicator.startAnimation()
        self.addSubview(self.indicator)
        
    }
    

//    deinit{ self.webView.delegate = nil }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
    func setLoading()
    {
        self.indicator.hidden = false
    }
    
    func setLoadingOff()
    {
        self.indicator.hidden = true
    }

}
