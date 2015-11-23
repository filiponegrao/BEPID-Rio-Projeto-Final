//
//  EncryptTools.swift
//  FFVChat
//
//  Created by Filipo Negrao on 20/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CryptoSwift



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
    
    class func enc(string: String, contact: String) -> String
    {
        let key = self.makeKey(contact)
        let iv = "forjaeofuturocar"
        
        let enc = try! string.aesEncrypt(key, iv: iv)
        
        return enc
    }
    
    class func dec(string: String) -> String
    {
        let key = self.makeKey(DAOUser.sharedInstance.getUsername())
        let iv = "forjaeofuturocar"
        
        let dec = try! string.aesDecrypt(key, iv: iv)
        
        return dec
    }
    
    class func encUsername(username: String) -> String
    {
        let key = self.makeKey(username)
        let iv = "forjaeofuturocar"
        
        let enc = try! username.aesEncrypt(key, iv: iv)
        
        return enc
    }
    
    class func decUsername(username: String) -> String
    {
        let key = self.makeKey(username)
        let iv = "forjaeofuturocar"
        
        let dec = try! username.aesDecrypt(key, iv: iv)
        
        return dec
    }
    
    class func getUsernameFromEncrpted(username: String) -> String?
    {
        let contacts = DAOContacts.sharedInstance.getAllContacts()
        
        for contact in contacts
        {
            if(self.encUsername(contact.username) == username)
            {
                return contact.username
            }
        }
        
        return nil
    }
    
    
    class func removeWhiteSpaces(string: String) -> String
    {
        let replaced = string.stringByReplacingOccurrencesOfString(" ", withString: "")

        return replaced
    }
    
    
    class func encImage(data: NSData, target: String) -> NSData
    {
        let key = self.makeKey(target)
        let iv = "forjaeofuturocar"
        let encrypted: NSData = try! data.encrypt(ChaCha20(key: key, iv: iv)!)

        return encrypted
    }
    
    class func decImage(data: NSData) -> NSData
    {
        let key = self.makeKey(DAOUser.sharedInstance.getUsername())
        let iv = "forjaeofuturocar"
        
        let decrypted: NSData = try! data.decrypt(ChaCha20(key: key, iv: iv)!)
        
        return decrypted
    }
    
    class func encKey(key: String) -> String
    {
        let key = self.makeKey("queroserrico")
        let iv = "nudesnudesnudess"
        
        let enc : String = try! key.encrypt(AES(key: key, iv: iv))
        
        return enc
    }
    
}

extension String {
    func aesEncrypt(key: String, iv: String) throws -> String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data!.arrayOfBytes(), padding: PKCS7())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        return String(result!)
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