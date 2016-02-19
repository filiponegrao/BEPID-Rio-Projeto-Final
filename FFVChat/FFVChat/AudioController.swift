//
//  AudioController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/02/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import Foundation
import AVFoundation

private let data : AudioController = AudioController()

class AudioController : NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate
{
    var audioRecorder : AVAudioRecorder!
    
    var audioPlayer : AVAudioPlayer!
    
    var audioSession : AVAudioSession!
    
    override init()
    {
        super.init()
        
        self.audioSession = AVAudioSession.sharedInstance()
        
        self.audioPlayer = AVAudioPlayer()
        self.audioPlayer.delegate = self
        
    }
    
    deinit
    {
        self.audioPlayer.delegate = nil
        self.audioRecorder.delegate = nil
    }
    
    class var sharedInstance : AudioController
    {
        return data
    }
    
    func playAudio(audio: NSData)
    {
        if(!self.audioRecorder.recording)
        {
            if(self.audioPlayer.playing)
            {
                self.audioPlayer.stop()
            }
            
            do
            {
                try self.audioPlayer = AVAudioPlayer(data: audio)
                self.audioPlayer.delegate = self
                
                do
                {
                    try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
                    self.audioPlayer.play()
                }
                catch
                {
                    print("audioSession error)")
                }

            }
            catch
            {
                return
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        do
        {
            try self.audioSession.setCategory(AVAudioSessionCategoryAmbient)
            self.audioPlayer.play()
        }
        catch
        {
            print("audioSession error)")
        }
    }
    
    func stopAudio()
    {
        
    }
    
    func startRecord()
    {
        
    }
    
    func stopRecord()
    {
        
    }
    
    func getAudioRecorder()
    {
        
    }
    
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        
    }
    
}