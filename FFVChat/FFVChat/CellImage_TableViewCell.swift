//
//  CellImage_TableViewCell.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellImage_TableViewCell: UITableViewCell
{
    var cellView : UIView!
    
    var backgroundLabel : UIView!
    
    var imageCell : UIImageView!
    
    var sentDate : UILabel!
    
    var loading : UIView!
    
    var indicator : NVActivityIndicatorView!
    
    var blur : UIVisualEffectView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame.size.height = screenWidth/6 * 2
        
        self.cellView = UIView(frame: CGRectMake(0, 0, self.frame.size.height , self.frame.size.height))
        self.cellView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(cellView)
        
        self.backgroundLabel = UIView(frame: CGRectMake(margemLateral, margemVertical, cellBackgroundWidth, cellBackgroundWidth))
        self.backgroundLabel.backgroundColor = UIColor.whiteColor()
        self.backgroundLabel.alpha = 0.1
        self.backgroundLabel.layer.cornerRadius = 10
        self.backgroundLabel.layer.zPosition = 0
        self.addSubview(self.backgroundLabel)
        
        self.imageCell = UIImageView(frame: CGRectMake(margemLateral+5, margemVertical+5, cellBackgroundWidth - 10, cellBackgroundWidth - dateTextHeigth*2 - 10))
        self.imageCell.clipsToBounds = true
        self.imageCell.layer.cornerRadius = 10
        self.imageCell.contentMode = .ScaleAspectFill
        self.imageCell.layer.zPosition = 5
        self.cellView.addSubview(imageCell)
        
        self.sentDate = UILabel(frame: CGRectMake(cellBackgroundWidth - dateTextWidth, cellBackgroundWidth - dateTextHeigth - margemVertical, dateTextWidth, dateTextHeigth))
        self.sentDate.text = "28-09-1992 09:00"
        self.sentDate.font = UIFont(name: "Helvetica", size: 8)
        self.sentDate.textAlignment = .Right
        self.sentDate.textColor = UIColor.whiteColor()
        self.cellView.addSubview(self.sentDate)
        
        
        let black = UIView(frame: CGRectMake(0,0,self.imageCell.frame.size.width/2, self.imageCell.frame.size.width/2))
        black.backgroundColor = UIColor.blackColor()
        black.alpha = 0.3
        black.center = self.imageCell.center
        black.layer.cornerRadius = black.frame.size.width/2
        
        self.loading = UIView(frame: self.frame)
        self.loading.backgroundColor = UIColor.clearColor()
        self.loading.addSubview(black)
        
        self.indicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, self.imageCell.frame.size.width/1.5, self.imageCell.frame.size.height/1.5), type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen)
        self.indicator.center = self.imageCell.center
        self.indicator.startAnimation()
        self.loading.addSubview(self.indicator)
        
        self.addSubview(self.loading)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    func setLoading()
    {
        self.loading.hidden = false
    }
    
    func setLoadingOff()
    {
        self.loading.hidden = true
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
