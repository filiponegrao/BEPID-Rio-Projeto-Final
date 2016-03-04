//
//  MessageStatus.swift
//  FFVChat
//
//  Created by Filipo Negrao on 05/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation

public enum messageStatus : String
{
    case Ready = "Sending"
    
    case Sent = "Sent"
    
    case ErrorSent = "ERROR"
    
    case Received = "Received"
    
    case Deleted = "Deleted"
    
    case Seen = "Seen"
}
