//
//  CellAudio_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 25/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class CellAudio_TableViewCell: UITableViewCell {

    weak var controller : Chat_ViewController!
    
    var indicator : NVActivityIndicatorView!

    var cellView : UIView!
    
    var backgroundLabel : UIView!

    var sentDate : UILabel!
    
    var playButton : UIButton!
    
    var index : Int!
    
    var slider : UISlider!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundLabel = UIView(frame: CGRectMake(margemLateral, margemVertical, screenWidth - 2*margemLateral, 60 - 2*margemVertical))
        self.backgroundLabel.backgroundColor = UIColor.whiteColor()
        self.backgroundLabel.alpha = 0.1
        self.backgroundLabel.layer.cornerRadius = 10
        self.backgroundLabel.layer.zPosition = 0
        self.addSubview(self.backgroundLabel)
        
        self.cellView = UIView(frame: CGRectMake(0, 0, self.frame.size.height , 60))
        self.cellView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(cellView)

        self.indicator = NVActivityIndicatorView(frame: CGRectMake(margemLateral + 10, margemVertical + 10, 60 - margemVertical - 20, 60 - margemVertical - 20), type: NVActivityIndicatorType.BallClipRotate, color: oficialGreen)
        self.indicator.startAnimation()
        self.cellView.addSubview(self.indicator)
        
        let h = Editor.heightForView("09:00", font: UIFont(name: "Gill Sans", size: 10)!, width: dateTextWidth)
        self.sentDate = UILabel(frame: CGRectMake(cellBackgroundWidth - dateTextWidth + margemLateral - 5, 60 - dateTextHeigth - margemVertical*2, dateTextWidth, h))
        self.sentDate.text = "09:00"
        self.sentDate.font = UIFont(name: "Gill Sans", size: 10)
        self.sentDate.textAlignment = .Right
        self.sentDate.textColor = UIColor.whiteColor()
        self.cellView.addSubview(self.sentDate)
        
        self.playButton = UIButton(frame: self.indicator.frame)
        self.playButton.setImage(UIImage(named: "playButtonBlack"), forState: .Normal)
        self.playButton.hidden = true
        self.playButton.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
        self.addSubview(self.playButton)
        
        self.slider = UISlider(frame: CGRectMake(self.playButton.frame.origin.x + self.playButton.frame.size.width, self.playButton.frame.origin.y, self.backgroundLabel.frame.size.width - self.playButton.frame.size.width - margemVertical - 20, self.playButton.frame.size.height))
        self.slider.setThumbImage(UIImage(named: "indicatorRed"), forState: .Normal)
        self.slider.minimumTrackTintColor = oficialDarkGray
        self.addSubview(self.slider)
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enablePlay()
    {
        self.indicator.hidden = true
        self.playButton.hidden = false
    }
    
    func disablePlay()
    {
        self.playButton.hidden = true
    }
    
    func setLoading()
    {
        self.indicator.hidden = false
        self.playButton.hidden = true
    }
    
    func play()
    {
        controller.playAudio(self.index)
    }
}
