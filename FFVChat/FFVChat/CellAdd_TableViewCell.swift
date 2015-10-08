//
//  CellAdd_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellAdd_TableViewCell: UITableViewCell {

    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var trustLevel: UILabel!
    
    @IBOutlet var addButton: MKButton!
    
    var invited : UIImageView!
    
    var invitedLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.photo.clipsToBounds = true
        self.photo.layer.cornerRadius = self.photo.frame.size.width/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addContact(sender: UIButton)
    {
        let username = self.username.text!
        self.addButton.hidden = true
        
        self.invited = UIImageView(frame: CGRectMake(addButton.frame.origin.x, addButton.frame.origin.y + 10, addButton.frame.size.width/2, addButton.frame.size.height/2))
        self.invited.image = UIImage(named: "accept")
        self.invited.center = CGPointMake(self.addButton.center.x, self.addButton.center.y/2)
        self.addSubview(self.invited)
        
        self.invitedLabel = UILabel(frame: CGRectMake(self.invited.frame.origin.x, self.invited.frame.origin.y + self.invited.frame.size.height, self.addButton.frame.size.width, self.addButton.frame.size.height/2))
        self.invitedLabel.text = "Invited"
        self.invitedLabel.textColor = oficialGreen
        self.invitedLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.invitedLabel)
        
        DAOFriendRequests.sharedInstance.sendRequest(username)
        DAOContacts.sendPushForFriendRequest(username)
    }
}
