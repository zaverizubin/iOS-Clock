

import UIKit
import AVFoundation
import StoreKit


class AlarmVibrationViewController: UITableViewController {
    
    
    let textCellIdentifier = "RowCell"
    
    let alarmModel:AlarmModel = AlarmModel()
    var soundPlayer:SoundPlayer = SoundPlayer()
    var alarm:Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section){
            case 0:
                return alarmModel.alarmVibrationDictionary.count
            case 1:
                return 1
            default:
                return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        case 0:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: textCellIdentifier)
            let myLabel = alarmModel.alarmVibrationDictionary[VibrationAlarmEnum(rawValue: indexPath.row)!]
            cell.textLabel?.text = myLabel
            if alarm!.vibration == VibrationAlarmEnum(rawValue: indexPath.row)!{
                cell.accessoryType = .Checkmark
            }
            return cell
        case 1:
            let cell = UITableViewCell(style: .Default, reuseIdentifier:
                textCellIdentifier)
            cell.textLabel?.text = "Create New Vibration"
            cell.accessoryType = .DisclosureIndicator
            return cell
        default:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
        
    }
    
    
    
    override
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
        
        if(indexPath.section == 0){
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: (alarm?.vibration.rawValue)!, inSection: 0))
            cell?.accessoryType = .None
            
            if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) {
                alarm?.vibration = VibrationAlarmEnum(rawValue: indexPath.row )!
                selectedRow.accessoryType = .Checkmark
                playVibration(indexPath)
            }
            
            return
        }
        
        if(indexPath.section == 1){
            stopVibration()
        }
        
    }
    
    
    func playVibration(indexPath:NSIndexPath){
        let file:String = alarmModel.alarmRingtoneDictionary[RingtoneAlarmEnum(rawValue: indexPath.row)!]!
        soundPlayer.stopSound()
        soundPlayer.playSound(file, loop: 10)
        
    }
    
    func stopVibration(){
        soundPlayer.stopSound()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        if let alarmSoundViewController = self.navigationController?.viewControllers[1] as? AlarmSoundViewController{
            alarmSoundViewController.selectedAlarmVibration =  (alarm?.vibration)!
        }
    }
    
}
