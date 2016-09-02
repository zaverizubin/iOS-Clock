//
//  RepearAlarmViewController.swift
//  StopWatch
//
//  Created by Mac Moham on 29/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class RepeatAlarmViewController: UITableViewController {
    
    // MARK: - Table view data source
    var alarmModel = AlarmModel()
    let textCellIdentifier = "RowCell"
    var selectedAlarmRepeats:[RepeatAlarmEnum] = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmModel.alarmRepeatDictionary.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        if(indexPath.row == 0){
            cell.hidden = true
        }else{
            cell.textLabel?.text = alarmModel.alarmRepeatDictionary[RepeatAlarmEnum(rawValue: indexPath.row)!]
            let selectedIndex = selectedAlarmRepeats.indexOf(RepeatAlarmEnum(rawValue: indexPath.row)!)
            if selectedIndex != nil{
               cell.accessoryType = .Checkmark
            }
            
        }
        
        return cell
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) {
            
            if(selectedRow.accessoryType == .Checkmark){
                selectedRow.accessoryType = .None
                selectedAlarmRepeats.removeAtIndex(selectedAlarmRepeats.indexOf(RepeatAlarmEnum(rawValue: indexPath.row)!)!)
            }else{
                selectedRow.accessoryType = .Checkmark
                selectedAlarmRepeats.append(RepeatAlarmEnum(rawValue: indexPath.row)!)
            }
            
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let addAlarmViewController = self.navigationController?.topViewController as? AddAlarmViewController{
            addAlarmViewController.selectedAlarmRepeats = selectedAlarmRepeats.sort{
                return $0.rawValue < $1.rawValue
            }
        }
    }

}
