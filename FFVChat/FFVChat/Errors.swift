//
//  Errors.swift
//  FFVChat
//
//  Created by Filipo Negrao on 31/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation


//** Erros **//


let error_noUser = NSError(domain: "Usuario nao encontrado", code: 001, userInfo: nil)

let error_selfUser = NSError(domain: "Usuario é o atua", code: 002, userInfo: nil)

let error_incompleteUser = NSError(domain: "Usuario desejado nao possui dados completos", code: 003, userInfo: nil)




