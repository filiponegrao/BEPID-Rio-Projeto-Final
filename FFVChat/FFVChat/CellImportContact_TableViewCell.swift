//
//  CellImportContact_TableViewCell.swift
//  FFVChat
//
//  Created by Filipo Negrao on 25/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class CellImportContact_TableViewCell: UITableViewCell
{
    @IBOutlet var photo: UIImageView!

    @IBOutlet var name: UILabel!
    
    @IBOutlet var checkMark: UIImageView!
    
    @IBOutlet var username: UILabel!
    
    var checked : Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.photo.contentMode = .ScaleAspectFill
        self.photo.layer.cornerRadius = self.photo.frame.size.width/2
        self.photo.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    
    func checkOn()
    {
        self.checked = true
        self.checkMark.image = UIImage(named: "checkOn")
    }
    
    func checkOff()
    {
        self.checked = false
        self.checkMark.image = UIImage(named: "checkOff")
    }
    
    func setClick()
    {
        if(self.checked)
        {
            self.checkOff()
        }
        else
        {
            self.checkOn()
        }
    }
}
