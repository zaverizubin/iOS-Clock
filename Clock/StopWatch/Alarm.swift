//
//  Alarm.swift
//  StopWatch
//
//  Created by Mac Moham on 24/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import Foundation


class Alarm: NSObject, NSCoding{
    
    var nc:NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    var notificationAlarmDoneKey:String = "alarmDone"
    
    var notificationSnoozeDoneKey:String = "snoozeDone"
    
    var myAlarmTimer:NSTimer?
    
    var mySnoozeTimer:NSTimer?
    
    var hour:Int = 0
    
    var minute:Int = 0
    
    var isPM:Bool = false
    
    var repeatAlarms:[RepeatAlarmEnum] = []
    
    var label:String = "Alarm"
    
    var vibration:VibrationAlarmEnum = VibrationAlarmEnum.Alert
    
    var sound:RingtoneAlarmEnum = RingtoneAlarmEnum.Radar
    
    var snooze:Bool = true
    
    var isActive:Bool = true{
        didSet{
            if(!isActive){
                if myAlarmTimer != nil{
                    myAlarmTimer!.invalidate()
                }
                if mySnoozeTimer != nil{
                    mySnoozeTimer!.invalidate()
                }
                
            }else{
                startAlarmTimer()
            }
        }
    }

    
    var displayTime : String{
        get {
            return String(format: "%02d:%02d",  hour, minute)
        }
    }

    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("alarms")
    
    override init(){
        super.init()
        
        hour = getHour()
        minute = getMinute()
        isPM = isTimePM()
 }
    
    init?(hour: Int, minute: Int, isPM: Bool, label:String, vibration:VibrationAlarmEnum, sound:RingtoneAlarmEnum, snooze:Bool, isActive:Bool) {
        super.init()
        self.hour = hour
        self.minute = minute
        self.isPM = isPM
        self.label = label
        self.vibration = vibration
        self.sound = sound
        self.snooze = snooze
        self.isActive = isActive
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let hour = aDecoder.decodeIntegerForKey(PropertyKey.hourKey)
        let minute = aDecoder.decodeIntegerForKey(PropertyKey.minuteKey)
        let isPM = aDecoder.decodeBoolForKey(PropertyKey.isPMKey)
        
        let label = aDecoder.decodeObjectForKey(PropertyKey.labelKey) as! String
        let vibration = aDecoder.decodeIntegerForKey(PropertyKey.vibrationKey)
        let sound = aDecoder.decodeIntegerForKey(PropertyKey.soundKey)
        let snooze = aDecoder.decodeBoolForKey(PropertyKey.snoozeKey)
        let isActive = aDecoder.decodeBoolForKey(PropertyKey.isActiveKey)
        
        self.init(hour: hour , minute: minute, isPM: isPM, label:label, vibration: VibrationAlarmEnum(rawValue: vibration)!, sound: RingtoneAlarmEnum(rawValue: sound)!, snooze: snooze, isActive: isActive)
        if(isActive){
            startAlarmTimer()
        }
    }
    
    func startAlarmTimer(){
        if myAlarmTimer != nil{
            myAlarmTimer!.invalidate()
        }
        myAlarmTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(Alarm.checkAlarmTimeup), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(myAlarmTimer!, forMode: NSRunLoopCommonModes)

    }
    
    func stopAlarmTimer(){
        myAlarmTimer?.invalidate()
    }
    
    func setToSnooze(){
        if mySnoozeTimer != nil{
            mySnoozeTimer!.invalidate()
        }
        mySnoozeTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(Alarm.onSnoozeTimeup), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(mySnoozeTimer!, forMode: NSRunLoopCommonModes)
    }
    
    dynamic func checkAlarmTimeup(){
        if(hour == getHour() && minute == getMinute() && isPM == isTimePM())
        {
            stopAlarmTimer()
            isActive = false
            let index = (AlarmModel.alarms as NSArray).indexOfObject(self)
            nc.postNotificationName(notificationAlarmDoneKey, object: index)
        }
    }
    
    dynamic func onSnoozeTimeup(){
        let index = (AlarmModel.alarms as NSArray).indexOfObject(self)
        nc.postNotificationName(notificationSnoozeDoneKey, object: index)
    }
    
    
    func getHour() -> Int{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour % 12 == 0 ? 12 : components.hour % 12
        return hour
    }
    
    func getMinute() -> Int{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        return components.minute
    }
    
    func isTimePM() -> Bool{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        return components.hour >= 12
    }
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let hourKey = "name"
        static let minuteKey = "minute"
        static let isPMKey = "isPMK"
        static let repeatAlarmsKey = "repeatAlarms"
        static let labelKey = "abel"
        static let vibrationKey = "vibration"
        static let soundKey = "sound"
        static let snoozeKey = "snooze"
        static let isActiveKey = "isActive"
       
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(hour, forKey: PropertyKey.hourKey)
        aCoder.encodeInteger(minute, forKey: PropertyKey.minuteKey)
        aCoder.encodeBool(isPM, forKey: PropertyKey.isPMKey)
        
        aCoder.encodeObject(label, forKey: PropertyKey.labelKey)
        aCoder.encodeInteger(vibration.rawValue, forKey: PropertyKey.vibrationKey)
        aCoder.encodeInteger(sound.rawValue, forKey: PropertyKey.soundKey)
        aCoder.encodeBool(snooze, forKey: PropertyKey.snoozeKey)
        aCoder.encodeBool(isActive, forKey: PropertyKey.isActiveKey)
    }
    
    
}

