//
//  CellAdd_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellAdd_TableViewCell: UITableViewCell {

    var photo: UIImageView!
    
    var username: UILabel!
    
    var trustLevel: UILabel!
    
    var addButton: MKButton!
    
    var invited : UIImageView!
    
    var invitedLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.photo = UIImageView(frame: CGRectMake(10, 10, self.frame.size.height - 20, self.frame.size.height - 20))
        self.photo.clipsToBounds = true
        self.photo.layer.cornerRadius = self.photo.frame.size.width/2
        self.addSubview(self.photo)
        
        self.username = UILabel(frame: CGRectMake(20 + self.photo.frame.size.width, 15, screenWidth/3 * 2, 20))
        self.username.textColor = oficialGreen
        self.username.font = UIFont(name: "SukhumvitSet-Light", size: 18)
        self.addSubview(self.username)
        
        self.trustLevel = UILabel(frame: CGRectMake(15 + self.photo.frame.size.width, self.username.frame.size.height + 15, screenWidth/3 * 2, 20))
        self.trustLevel.textColor = oficialLightGray
        self.addSubview(self.trustLevel)
        
        self.addButton = MKButton(frame: CGRectMake(screenWidth - screenWidth/8 - 10, 15, screenWidth/8, screenWidth/8))
        self.addButton.setImage(UIImage(named: "addContactButton"), forState: .Normal)
        self.addButton.addTarget(self, action: "addContact", forControlEvents: .TouchUpInside)
        self.addSubview(self.addButton)
        
        self.invited = UIImageView(frame: CGRectMake(screenWidth - screenWidth/8 - 10, 15, screenWidth/8, screenWidth/8))
        self.invited.image = UIImage(named: "accept")
        //        self.invited.contentMode = .ScaleAspectFit
        self.invited.hidden = true
        self.addSubview(self.invited)
        
        self.invitedLabel = UILabel(frame: CGRectMake(self.username.frame.origin.x, self.username.frame.origin.y + self.username.frame.size.height, screenWidth/3 * 2, 20))
        self.invitedLabel.text = "Invited"
        self.invitedLabel.textColor = oficialLightGray
        self.invitedLabel.adjustsFontSizeToFitWidth = true
        self.invitedLabel.hidden = true
        self.invitedLabel.font = UIFont(name: "SukhumvitSet-Light", size: 18)
        self.addSubview(self.invitedLabel)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addContact()
    {
        let username = self.username.text!
        self.addButton.hidden = true
        
        self.invited.hidden = false
        self.invitedLabel.hidden = false
    
        
        DAOFriendRequests.sharedInstance.sendRequest(username)
    }
}
