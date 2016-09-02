//
//  Timer.swift
//  StopWatch
//
//  Created by Kaustubh on 7/29/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import Foundation
import UIKit

class StopWatchTimer :NSObject{
    
    
    let defaultTimeString:String = "00:00:00"
    
    var label:UILabel?
    var myTimer:NSTimer?
    var currentTime:Int = 0
    var elapsedTime:Int = 0
    static var lapTimes:[String] = [String]()
    static var elapsedTimes:[String] = [String]()
    
    var displayTime : String{
        get {
            
            let minutes = (currentTime / 1000) / 60
            let seconds = (currentTime / 1000) % 60
            let milliseconds = (currentTime % 1000) / 10
            return String(format: "%02d:%02d:%02d",  minutes, seconds, milliseconds)
        
        }
    }
    
    
    
    func updateDisplay(label:UILabel){
        self.label = label
    }
    
    func addLapTime(){
        StopWatchTimer.lapTimes.insert(displayTime, atIndex: 0)
    }
    
    func addElapsedTime(){
       StopWatchTimer.elapsedTimes.insert(displayTime, atIndex: 0)
    }
    
    func startTimer(){
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(StopWatchTimer.updateTimer(_:)), userInfo: nil, repeats: true)

    }
    
    func stopTimer(){
        myTimer?.invalidate()
    }
    
    func resetTime(){
        currentTime = 0
        label?.text = defaultTimeString as String
    }
    
    func updateTimer(nsTimer:NSTimer){
        currentTime+=10
        label?.text = displayTime as String
    }

    
    
    
}