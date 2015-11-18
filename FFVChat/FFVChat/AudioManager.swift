//
//  AudioManager.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/11/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

//import Foundation
//import AVFoundation
//
//
//class AudioManager
//{
//    var soud : AVAudioPlayer!
//    
//    class func playBip()
//    {
//        var soundPath:NSURL?
//        
//        if let path = NSBundle.mainBundle().pathForResource("messageup.mp3", ofType: nil) {
//            soundPath = NSURL(fileURLWithPath: path)
//            do {
//                print(path)
//                let sound = try AVAudioPlayer(contentsOfURL: soundPath!, fileTypeHint:nil)
//                sound.prepareToPlay()
//                sound.volume = 1
//                sound.play()
//            } catch {
//                print("erro")
//            }
//        }
//    }
//}