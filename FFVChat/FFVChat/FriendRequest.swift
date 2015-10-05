//
//  FriendRequest.swift
//  FFVChat
//
//  Created by Filipo Negrao on 04/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation


class FriendRequest
{
    let sender : String
    
    let target : String
    
    init(sender : String, target: String)
    {
        self.sender = sender
        self.target = target
    }
}