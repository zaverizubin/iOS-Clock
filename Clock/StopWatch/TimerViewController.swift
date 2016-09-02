//
//  TimerViewController.swift
//  StopWatch
//
//  Created by Kaustubh on 8/5/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var hoursPicker: UIPickerView!
    
    @IBOutlet weak var minutesPicker: UIPickerView!
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var minsLabel: UILabel!
    
    @IBOutlet weak var selectedRingtoneLabel: UILabel!
    
    var selectedRingtone = RingtoneModel().defaultRingtone
    
    var countdownTimer = CountdownTimer()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        hoursPicker.delegate = self
        hoursPicker.dataSource = self
        minutesPicker.delegate = self
        minutesPicker.dataSource = self
        
        configureView(false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView(isCountdownMode:Bool){
        selectedRingtoneLabel.text = selectedRingtone
        hoursPicker.selectRow(12, inComponent: 0, animated: false)
        minutesPicker.selectRow(30, inComponent: 0, animated: false)
        
        startButton.setTitle("Start", forState:.Normal)
        startButton.setTitleColor(UIColor.greenColor() , forState:.Normal)
        pauseButton.setTitle("Pause", forState:.Normal)
        
        toggleUIElements(isCountdownMode)
        countdownTimer.nc.addObserver(self, selector: #selector(TimerViewController.displayCountDown), name: countdownTimer.notificationUpdateKey, object: nil)
        countdownTimer.nc.addObserver(self, selector: #selector(TimerViewController.countDownComplete), name: countdownTimer.notificationDoneKey, object: nil)
        
        self.tabBarItem.image = UIImage(named: "Timer")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "Timer-down")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    func toggleUIElements(isCountdownMode:Bool){
        hoursPicker.hidden = isCountdownMode
        minutesPicker.hidden = isCountdownMode
        hoursLabel.hidden = isCountdownMode
        minsLabel.hidden = isCountdownMode
        countdownLabel.hidden = !isCountdownMode
        pauseButton.enabled = isCountdownMode;

    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    
    // MARK: - Navigation

 
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView === hoursPicker){
            return countdownTimer.hours.count
        }else{
            return countdownTimer.minutes.count
        }

    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === hoursPicker{
            return String(countdownTimer.hours[row])
        }else{
            return String(countdownTimer.minutes[row])
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === minutesPicker{
            if(Int(hoursPicker.selectedRowInComponent(0)) == 0
                && Int(minutesPicker.selectedRowInComponent(0)) == 0){
                minutesPicker.selectRow(1, inComponent: 0, animated: true)
            }
        }
    }
    
    func displayCountDown(){
        countdownLabel.text = countdownTimer.countDownTime
    }
    
    func countDownComplete(){
        let soundPlayer = SoundPlayer()
        soundPlayer.playSound(self.selectedRingtone)

        let alertController = UIAlertController(title: "", message:"Timer Done", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            switch action.style{
            case .Default, .Cancel, .Destructive:
                self.configureView(false)
                soundPlayer.stopSound()
            }
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    //Mark Event Handlers
    
    @IBAction func startButtonClick(sender: UIButton) {
        if(sender.currentTitle == "Start" )
        {
            startButton.setTitle("Cancel", forState:.Normal)
            sender.setTitleColor(UIColor.redColor() , forState:.Normal)
            toggleUIElements(true)
            countdownTimer.startCountDown(hoursPicker.selectedRowInComponent(0), selectedMinuteIndex:minutesPicker.selectedRowInComponent(0))
            displayCountDown()
        }else{
            configureView(false)
            countdownTimer.stopCountDown()
        }
        
    }
    
    
    @IBAction func pauseButtonClick(sender: UIButton) {
        if(sender.currentTitle == "Pause" )
        {
            pauseButton.setTitle("Resume", forState:.Normal)
            countdownTimer.stopCountDown()
        }else{
            pauseButton.setTitle("Pause", forState:.Normal)
            countdownTimer.resumeCountDown()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectRingtoneSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let ringtoneTableViewController = navigationController.topViewController as? RingToneTableViewController{
                        ringtoneTableViewController.ringtone = selectedRingtone
                }
            }
        }
    }
    
    @IBAction func cancelToTimerViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveTimerRingtone(segue:UIStoryboardSegue) {
        
        if let ringToneTableViewController = segue.sourceViewController as? RingToneTableViewController {
            
            //add the new player to the players array
            
            selectedRingtone = ringToneTableViewController.ringtone
            selectedRingtoneLabel.text = selectedRingtone
        }
    }

    
    
}
