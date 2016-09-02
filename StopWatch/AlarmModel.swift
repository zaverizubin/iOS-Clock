//
//  AlarmModel.swift
//  StopWatch
//
//  Created by Mac Moham on 24/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import Foundation

class AlarmModel{
    
    
    static var alarms:[Alarm] = []
    
    let alarmRepeatDictionary:[RepeatAlarmEnum:String] = [RepeatAlarmEnum.Never:"Never", RepeatAlarmEnum.Sun:"Every Sunday", RepeatAlarmEnum.Mon:"Every Monday", RepeatAlarmEnum.Tues:"Every Tuesday", RepeatAlarmEnum.Wed:"Every Wednesday", RepeatAlarmEnum.Thurs:"Every Thursday", RepeatAlarmEnum.Fri:"Every Friday", RepeatAlarmEnum.Sat:"Every Saturday"]
    
    let alarmVibrationDictionary:[VibrationAlarmEnum:String] = [VibrationAlarmEnum.Alert:"Alert (Default)", VibrationAlarmEnum.HeartBeat:"HeartBeat",VibrationAlarmEnum.Quick:"Quick",VibrationAlarmEnum.Rapid:"Rapid",VibrationAlarmEnum.SOS:"S.O.S",VibrationAlarmEnum.Staccato:"Staccato",VibrationAlarmEnum.Symphony:"Symphony"]
    
    let alarmRingtoneDictionary:[RingtoneAlarmEnum:String] = [RingtoneAlarmEnum.Radar:"Radar (Default)", RingtoneAlarmEnum.Apex:"Apex",RingtoneAlarmEnum.Beacon:"Beacon", RingtoneAlarmEnum.Bulletin:"Bulletin", RingtoneAlarmEnum.ByTheSeaside:"ByTheSeaside",RingtoneAlarmEnum.Chimes:"Chimes", RingtoneAlarmEnum.Circuit:"Circuit", RingtoneAlarmEnum.Cosmic:"Cosmic", RingtoneAlarmEnum.Crystals:"Crystals", RingtoneAlarmEnum.Hillside:"Hillside", RingtoneAlarmEnum.Illuminate:"Illuminate", RingtoneAlarmEnum.NigthOwl:"NigthOwl", RingtoneAlarmEnum.Opening:"Opening", RingtoneAlarmEnum.Playtime:"Playtime" , RingtoneAlarmEnum.Presto:"Presto", RingtoneAlarmEnum.Radiate:"Radiate", RingtoneAlarmEnum.Ripples:"Ripples"]
    
    let alarmSuffixes:[String] = ["Never", "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    
    var hours = [Int]()
    var minutes = [Int]()
    
    init(){
        for i in 0...59 {
            if(i<=12 && i>0){
                hours.append(i)
            }
            minutes.append(i)
        }
            }

    
    
}

enum  RepeatAlarmEnum:Int {
    case Never = 0
    case Sun = 1
    case Mon = 2
    case Tues = 3
    case Wed = 4
    case Thurs = 5
    case Fri = 6
    case Sat = 7
}

enum  VibrationAlarmEnum:Int {
    case Alert = 0
    case HeartBeat = 1
    case Quick = 2
    case Rapid = 3
    case SOS = 4
    case Staccato = 5
    case Symphony = 6
}

enum  RingtoneAlarmEnum:Int {
    case None = -1
    case Radar = 0
    case Apex = 1
    case Beacon = 2
    case Bulletin = 3
    case ByTheSeaside = 4
    case Chimes = 5
    case Circuit = 6
    case Cosmic = 7
    case Crystals = 8
    case Hillside = 9
    case Illuminate = 10
    case NigthOwl = 11
    case Opening = 12
    case Playtime = 13
    case Presto = 14
    case Radiate = 15
    case Ripples = 16
    
}