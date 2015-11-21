//
//  EncryptTools.swift
//  FFVChat
//
//  Created by Filipo Negrao on 20/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation


class EncryptTools
{
    class func makeKey(username: String) -> String
    {
        var result = String()
        
        if(username.characters.count > 32)
        {
            for i in 0...31
            {
                result.append(username[i])
            }
        }
        else
        {
            for i in 1...(32-username.characters.count)
            {
                result += "0"
            }
            
            result += username
        }
        
        return result
    }
}


extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}