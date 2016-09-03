//
//  AlarmViewController.swift
//  StopWatch
//
//  Created by Mac Moham on 24/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var noAlarmsLabel: UILabel!
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let textCellIdentifier = "RowCell"
    
    let noAlarmsText = "No Alarms"
    
    var alarmModel:AlarmModel = AlarmModel()
    
    var selectedAlarmIndex:Int?
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let savedAlarms = loadAlarms() {
            AlarmModel.alarms = savedAlarms
            addNotificationListeners()
        }
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI(){
        toggleEditButton()
        self.tabBarItem.image = UIImage(named: "Alarm")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "Alarm-down")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        updateNoAlarmsText()

    }

    func addNotificationListeners(){
        for alarm in AlarmModel.alarms{
            alarm.nc.removeObserver(self)
            alarm.nc.addObserver(self, selector: #selector(AlarmViewController.onAlarmTimeout), name: alarm.notificationDoneKey, object: nil)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmModel.alarms.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! AlarmCustomRowCell
        
        let alarm = AlarmModel.alarms[indexPath.row]
        cell.tag = indexPath.row
        cell.configureUI(alarm)
      
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let alarm = AlarmModel.alarms[indexPath.row]
            alarm.stopTimer()
            AlarmModel.alarms.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            updateNoAlarmsText()
            AlarmModel.persistAlarms()
        }
        toggleEditButton()
    }
    
    func toggleEditButton(){
        if(AlarmModel.alarms.count==0){
            editButton.enabled = false
            editButton.tintColor = UIColor.clearColor()
        }else{
            editButton.enabled = true
            editButton.tintColor = .None
        }
    }
    
    func dismissEditingMode(){
        alarmTableView.setEditing(false, animated: false)
        editButton.title = "Edit"
        toggleEditButton()

    }
   
    func updateNoAlarmsText()
    {
        noAlarmsLabel.text = AlarmModel.alarms.count>0 ? "" : noAlarmsText;
    }
    
        
    func loadAlarms() -> [Alarm]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Alarm.ArchiveURL.path!) as? [Alarm]
        
    }
    
    func onAlarmTimeout(notification: NSNotification){
        
        let index = notification.object as! Int
        let alarm = AlarmModel.alarms[index]
        
        let cell = alarmTableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! AlarmCustomRowCell
        cell.onAlarmDone()
        
        displayAlert(alarm)
    }
    
    func displayAlert(alarm: Alarm){
        
        let soundPlayer = SoundPlayer()
        soundPlayer.playSound(AlarmModel().alarmRingtoneDictionary[alarm.sound]!)
        
        let alertController = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        if(alarm.snooze){
            alertController.addAction(UIAlertAction(title: "Snooze", style: UIAlertActionStyle.Default, handler: nil))
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            soundPlayer.stopSound()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
       
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destViewController = segue.destinationViewController as? UINavigationController{
            if let addAlarmViewController = (destViewController.topViewController as? AddAlarmViewController){
                if(segue.identifier == "editAlarmSegue"){
                    if let selectedIndex =  (alarmTableView.indexPathForSelectedRow?.row){
                        addAlarmViewController.alarm = AlarmModel.alarms[selectedIndex]
                    }
                }else if(segue.identifier == "createNewAlarmSegue"){
                    addAlarmViewController.alarm = Alarm()
                }
            }
        }
    }
    

    
    @IBAction func onEditButtonClick(sender: UIBarButtonItem) {
        if(sender.title!.lowercaseString == "edit"){
            alarmTableView.setEditing(true, animated: true)
            sender.title = "Done"
        }else{
            alarmTableView.setEditing(false, animated: true)
            sender.title = "Edit"
        }
        
    }
    
    
    @IBAction func cancelToAlarmViewController(segue:UIStoryboardSegue) {
        if segue.sourceViewController is AddAlarmViewController {
            dismissEditingMode()
            AlarmModel.persistAlarms()
            alarmTableView.reloadData()
        }
    }
    
    @IBAction func saveToAlarmViewController(segue:UIStoryboardSegue) {
        if segue.sourceViewController is AddAlarmViewController {
            dismissEditingMode()
            updateNoAlarmsText()
            alarmTableView.reloadData()
            addNotificationListeners()
            AlarmModel.persistAlarms()
        }
        
    }
    
    
    
    
    
}
