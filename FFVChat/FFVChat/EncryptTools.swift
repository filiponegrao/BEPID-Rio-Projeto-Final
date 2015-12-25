//
//  EncryptTools.swift
//  FFVChat
//
//  Created by Filipo Negrao on 20/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CryptoSwift


/**
 * Classe responsavel pela criptografia de dados.
 * - Criada em: 18/10/2015
 * - Ultima atualizacao: 18/12/2015
 *
 * Obs: Utiliza o framewrok CryptoSwift, encontrado
 * na pagina awesome swift no github.
 *
 */
class EncryptTools
{
    /**
     * Cria uma chave de criptografia baseado no username
     * passado como parametro.
     */
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
                result += "f"
            }
            
            result += username
        }
        
        return result
    }
    
    /**
     * Criptografa um texto passado como parametro, utilizando
     * o contato tambem passado como parametro como parte da chave
     * para tal criptografia.
     */
    class func encryptText(string: String, contact: String) -> String
    {
        let key = self.makeKey(contact)
        let iv = "forjaeofuturocar"
        
        let enc = try! string.aesEncrypt(key, iv: iv)
        
        return enc
    }
    
    /**
     * Descriptografa um texto passado como parametro.
     * Utilizada o nome de usuario corrente como chave para
     * tal descriptografia.
     */
    class func decryptText(string: String) -> String
    {
        let key = self.makeKey(DAOUser.sharedInstance.getUsername())
        let iv = "forjaeofuturocar"
        
        let dec = try! string.aesDecrypt(key, iv: iv)
        
        return dec
    }
    
    /**
     * Criptografa um nome de usuario. Utiliza o proprio
     * nome como chave da criptografia do mesmo.
     */
    class func encryptUsername(username: String) -> String
    {
        let key = self.makeKey(username)
        let iv = "forjaeofuturocar"
        
        let enc = try! username.aesEncrypt(key, iv: iv)
        
        return enc
    }
    
    /**
     * Recebe como parmetro um nume de usuario ja criptografado,
     * e retorna um nome de usuario descriptografado se o mesmo exisitir.
     * Vale ressaltar que a funcao retornará um nome, apenas se o mesmo
     * estiver presente nos contatos.
     */
    class func getUsernameFromEncrpted(username: String) -> String?
    {
        let contacts = DAOContacts.sharedInstance.getAllContacts()
        
        for contact in contacts
        {
            if(self.encryptUsername(contact.username) == username)
            {
                return contact.username
            }
        }
        
        return nil
    }
    
    
    /**
     * Recebe uma imagem em forma de daados e um nome de usuario como parametro.
     * retorna um conjunto de dados ja criptografados referente aos passados.
     * O nome de usuario é parte da chave de criptografia.
     */
    class func encImage(data: NSData, targetUsername: String) -> NSData
    {
        let key = self.makeKey(targetUsername)
        let iv = "forjaeofuturocar"
        let encrypted: NSData = try! data.encrypt(ChaCha20(key: key, iv: iv)!)

        return encrypted
    }
    
    /**
     * Recebe um conjunto de dados referentes a uma imagem,
     * e utilizando o nome de usuario atual como parte da chave
     * de descriptografia, descriptografa os bytes e retorna.
     */
    class func decImage(data: NSData) -> NSData
    {
        let key = self.makeKey(DAOUser.sharedInstance.getUsername())
        let iv = "forjaeofuturocar"
        
        let decrypted: NSData = try! data.decrypt(ChaCha20(key: key, iv: iv)!)
        
        return decrypted
    }
    
    /**
     * Cria uma chave ilegível.
     * Deve receber uma chave, única e concisa.
     * e retorna a mesma, de forma ilegível.
     */
    class func encKey(myKey: String) -> String
    {
        let key = self.makeKey("queroserrico")
        let iv = "nudesnudesnudess"
        
        let enc : String = try! myKey.encrypt(AES(key: key, iv: iv))
        
        return enc
    }
    
}

extension String
{
    func aesEncrypt(key: String, iv: String) throws -> String
    {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(), padding: PKCS7())
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String
    {
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