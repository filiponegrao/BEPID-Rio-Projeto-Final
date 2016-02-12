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
    case Ready = "Enviando..."
    
    case Sent = "Enviada!"
    
    case ErrorSent = "Erro ao enviar"
    
    case Received = "Recebida"
    
    case Deleted = "Excluida"
    
    case Seen = "Visualizada"
}
