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
    
    var webView : UIWebView!

    var sentDate : UILabel!
    
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
        
        self.webView = UIWebView(frame: CGRectMake(margemLateral+5, margemVertical+5, cellBackgroundWidth - 10, cellBackgroundWidth - dateTextHeigth*2 - 10))
        self.webView.clipsToBounds = true
        self.webView.layer.cornerRadius = 10
//        self.webView.contentMode = .ScaleAspectFill
        self.webView.layer.zPosition = 5
        self.webView.userInteractionEnabled = false
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.cellView.addSubview(webView)
        
        self.bringSubviewToFront(self.webView)
        
        let h = Editor.heightForView("09:00", font: UIFont(name: "Gill Sans", size: 10)!, width: dateTextWidth)
        self.sentDate = UILabel(frame: CGRectMake(cellBackgroundWidth - dateTextWidth + margemLateral - 5, cellBackgroundWidth - dateTextHeigth - margemVertical, dateTextWidth, h))
        self.sentDate.text = "09:00"
        self.sentDate.font = UIFont(name: "Gill Sans", size: 10)
        self.sentDate.textAlignment = .Right
        self.sentDate.textColor = UIColor.whiteColor()
        self.cellView.addSubview(self.sentDate)

    }
    

    deinit{ self.webView.delegate = nil }
    
    
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
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        webView.scalesPageToFit = true
        webView.scrollView.zoomScale = 2
    }

}
