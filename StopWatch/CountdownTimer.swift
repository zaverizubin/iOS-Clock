//
//  TimerData.swift
//  StopWatch
//
//  Created by Kaustubh on 8/5/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import Foundation



class CountdownTimer{
    
    var nc:NSNotificationCenter = NSNotificationCenter.defaultCenter()
    var notificationUpdateKey:String = "countdownUpdate"
    var notificationDoneKey:String = "countdownDone"
    
    var myTimer:NSTimer?
    
    var hours = [Int]()
    var minutes = [Int]()
    var chimes = [String]()
    
    var countdownHours = 0
    var countdownMinutes = 0
    var countdownSeconds = 0
    
    var countDownTime :String{
        get{
            var x = countdownHours<10 ? "0" + String(countdownHours):String(countdownHours)
            x += ":" + (countdownMinutes<10 ? "0" + String(countdownMinutes):String(countdownMinutes))
            x += ":" + (countdownSeconds<10 ? "0" + String(countdownSeconds):String(countdownSeconds))
            return x
        }
    }
    
    
    
    init(){
        for i in 0...59 {
            if(i<=23){
                hours.append(i)
            }
            minutes.append(i)
        }
    }
    
   
    
    func startCountDown(selectedHourIndex:Int, selectedMinuteIndex:Int){
        countdownHours = hours[selectedHourIndex]
        countdownMinutes = minutes[selectedMinuteIndex]
        countdownSeconds = 0
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CountdownTimer.updateTimer), userInfo: nil, repeats: true)
    }
    
    func resumeCountDown(){
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CountdownTimer.updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopCountDown(){
        myTimer?.invalidate()
    }
    
    func resetCountDown(){
        countdownHours = 0
        countdownMinutes = 0
        countdownSeconds = 0
    }
    
    dynamic func updateTimer(){
        countdownSeconds -= 1
        
        if(countdownSeconds < 0){
            countdownSeconds = 59
            countdownMinutes -= 1
        }
        
        if(countdownMinutes < 0){
            countdownMinutes = 59
            countdownHours -= 1
        }
        
        if countdownHours==0 && countdownMinutes==0 && countdownSeconds==0{
            stopCountDown()
            nc.postNotificationName(notificationDoneKey, object: nil)
        }else{
            nc.postNotificationName(notificationUpdateKey, object: nil)
        }
        
    }
    
    
    
}