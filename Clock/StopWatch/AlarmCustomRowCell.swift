//
//  StopWatchTableViewCell.swift
//  StopWatch
//
//  Created by Mac Moham on 24/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class AlarmCustomRowCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var amPMLabel: UILabel!
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var enableSwitch: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func willTransitionToState(state: UITableViewCellStateMask) {
        if(state.rawValue == 1){
            self.enableSwitch.hidden = true;
          
        }else if(state.rawValue == 0){
            self.enableSwitch.hidden = false;
           
        }
    }

    @IBAction func onUISwitchChange(sender: UISwitch) {
        self.contentView.alpha = sender.on ? 1.0 : 0.5
        let alarm = AlarmModel.alarms[self.tag]
        alarm.isActive = sender.on
        if(sender.on){
            alarm.startAlarmTimer()
        }
        AlarmModel.persistAlarms()
    }
    
    func configureUI(alarm:Alarm){
        timeLabel.text =  alarm.displayTime
        amPMLabel.text =  alarm.isPM ? "PM":"AM"
        alarmLabel.text = alarm.label
        enableSwitch.on = alarm.isActive
        self.contentView.alpha = alarm.isActive ? 1.0 : 0.5
    }
    
    func onAlarmDone(){
        self.enableSwitch.on = false
        self.contentView.alpha = 0.5
    }
}
