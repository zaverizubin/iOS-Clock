//
//  SoundPlayer.swift
//  StopWatch
//
//  Created by Kaustubh on 8/18/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SoundPlayer {
    
    var alarmAudioPlayer: AVAudioPlayer?
    
    func playSound(nameOfAudioFileInAssetCatalog: String, loop:Int? = -1) {
        
        if let sound = NSDataAsset(name: nameOfAudioFileInAssetCatalog) {
            do {
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                try alarmAudioPlayer = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
                alarmAudioPlayer!.numberOfLoops = loop!
                alarmAudioPlayer!.play()
            } catch {
                print("error initializing AVAudioPlayer")
            }
        }
    }
    
    func stopSound(){
        if(alarmAudioPlayer != nil)
        {
            alarmAudioPlayer!.stop()
            alarmAudioPlayer = nil
            
        }
    }
};