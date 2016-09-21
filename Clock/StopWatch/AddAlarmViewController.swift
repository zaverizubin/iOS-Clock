//
//  AddAlarmViewController.swift
//  StopWatch
//
//  Created by Mac Moham on 24/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class AddAlarmViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var hoursPicker: UIPickerView!
    
    @IBOutlet weak var minutesPicker: UIPickerView!
    
    @IBOutlet weak var amPMPicker: UIPickerView!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBOutlet weak var snoozeSwitch: UISwitch!
    
    var alarm:Alarm?
    var alarmModel:AlarmModel = AlarmModel()
    
    var selectedAlarmSound:RingtoneAlarmEnum = RingtoneAlarmEnum.Radar{
        didSet{
            if(selectedAlarmSound == RingtoneAlarmEnum.None){
               soundLabel.text = "None"
            }else{
               soundLabel.text = alarmModel.alarmRingtoneDictionary[selectedAlarmSound]
            }
            
        }
    }
    
    var selectedAlarmRepeats:[RepeatAlarmEnum] = [] {
        didSet {
            if(selectedAlarmRepeats.count==0){
                repeatLabel.text = alarmModel.alarmSuffixes[RepeatAlarmEnum.Never.rawValue]
            }else{
                var repeatAlarms:String = ""
                if(selectedAlarmRepeats.count == (alarmModel.alarmRepeatDictionary.count)-1){
                    repeatLabel.text = "Every Day"
                }else{
                    for repeatAlarm in selectedAlarmRepeats {
                        repeatAlarms += alarmModel.alarmSuffixes[repeatAlarm.rawValue] + " "
                    }
                    repeatLabel.text = repeatAlarms

                }
            }
            
        }
    }
    
    
    
    
    var pickerViewHoursMiddle:Int?
    var pickerViewMinutesMiddle:Int?
    let pickerViewRows = 10_000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoursPicker.delegate = self
        hoursPicker.dataSource = self
        minutesPicker.delegate = self
        minutesPicker.dataSource = self
        amPMPicker.delegate = self
        amPMPicker.dataSource = self
        
        configureUI()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI(){
        var hour:Int
        var minute:Int
        var isPM:Bool
        
        hour = alarm!.hour
        minute = alarm!.minute
        isPM = alarm!.isPM
        selectedAlarmRepeats = alarm!.repeatAlarms
        alarmLabel.text = alarm!.label
        soundLabel.text = alarm!.sound == RingtoneAlarmEnum.None ? "None" : alarmModel.alarmRingtoneDictionary[alarm!.sound]
        snoozeSwitch.on = alarm!.snooze
        
        pickerViewHoursMiddle = ((pickerViewRows / alarmModel.hours.count) / 2) * alarmModel.hours.count
        pickerViewMinutesMiddle = ((pickerViewRows / alarmModel.minutes.count) / 2) * alarmModel.minutes.count
        
        hoursPicker.selectRow(pickerViewHoursMiddle! + alarmModel.hours.indexOf(hour)!, inComponent: 0, animated: false)
        minutesPicker.selectRow(pickerViewMinutesMiddle! + alarmModel.minutes.indexOf(minute)!, inComponent: 0, animated: false)
        amPMPicker.selectRow(!isPM ? 0:1, inComponent: 0, animated: false)
        
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView === hoursPicker){
            return pickerViewRows
        }else if(pickerView === minutesPicker){
            return pickerViewRows
        }else{
            return 2
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === hoursPicker{
            return String(alarmModel.hours[row % alarmModel.hours.count])
        }else if(pickerView === minutesPicker){
            let minutes:Int = alarmModel.minutes[row % alarmModel.minutes.count]
            return (minutes<10) ? "0" + String(minutes):String(minutes)
        }else{
            return row==0 ? "AM":"PM"
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === hoursPicker{
            let newRow = pickerViewHoursMiddle! + (row % alarmModel.hours.count)
            pickerView.selectRow(newRow, inComponent: 0, animated: false)
        }else if(pickerView === minutesPicker){
            let newRow = pickerViewMinutesMiddle! + (row % alarmModel.minutes.count)
            pickerView.selectRow(newRow, inComponent: 0, animated: false)
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((AlarmModel.alarms as NSArray).indexOfObject(alarm!) > AlarmModel.alarms.count){
            return 7
        }else{
            return 8
        }
    }
    
    
    
    @IBAction func onDeleteAlarmClick(sender: AnyObject) {
        var index:Int?
        index = (AlarmModel.alarms as NSArray).indexOfObject(alarm!)
        AlarmModel.alarms.removeAtIndex(index!)
        performSegueWithIdentifier("cancelToAlarmSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.Plain, target:nil, action:nil)
        
        switch(segue.identifier!){
            case "editRepeatAlarmSegue" :
                (segue.destinationViewController as? RepeatAlarmViewController)?.selectedAlarmRepeats = selectedAlarmRepeats
                break
            case "editAlarmLabelSegue" :
            (segue.destinationViewController as? AlarmLabelViewController)?.alarmLabel = alarmLabel.text!
                break
            case "editAlarmSoundSegue" :
                (segue.destinationViewController as? AlarmSoundViewController)?.alarm = alarm
                break
            case "saveToAlarmSegue" :
                var index:Int?
                index = (AlarmModel.alarms as NSArray).indexOfObject(alarm!)
                
                alarm!.hour = alarmModel.hours[hoursPicker.selectedRowInComponent(0) % alarmModel.hours.count]
                alarm!.minute = alarmModel.minutes[minutesPicker.selectedRowInComponent(0) % alarmModel.minutes.count]
                alarm!.repeatAlarms = selectedAlarmRepeats
                alarm!.isPM = amPMPicker.selectedRowInComponent(0) == 1
                alarm!.label = alarmLabel.text!
                alarm!.snooze = snoozeSwitch.on
                alarm!.isActive = true
                
                if(index < AlarmModel.alarms.count){
                    AlarmModel.alarms[index!] = alarm!
                }else{
                   AlarmModel.alarms.append(alarm!)
                }
                alarm!.startAlarmTimer()
                break
        default:
            break
        }
        
        
        
        
    }
    
    

}
