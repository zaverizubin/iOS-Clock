//
//  ViewController.swift
//  StopWatch
//
//  Created by Kaustubh on 7/29/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var primaryTimeLabel: UILabel!
    
    @IBOutlet weak var secondaryTimeLabel: UILabel!
    
    @IBOutlet weak var buttonReset: UIButton!
    
    @IBOutlet weak var buttonStart: UIButton!
    
    @IBOutlet weak var lapTimeTableView: UITableView!
    
    
    let textCellIdentifier = "RowCell"
    var primaryTimer:StopWatchTimer
    var secondaryTimer:StopWatchTimer
   
    
    required init?(coder aDecoder: NSCoder) {
        
        primaryTimer = StopWatchTimer()
        secondaryTimer = StopWatchTimer()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lapTimeTableView.delegate = self
        lapTimeTableView.dataSource = self
        configureUI()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func configureUI(){
        buttonReset.enabled = false;
        primaryTimer.updateDisplay(primaryTimeLabel!)
        secondaryTimer.updateDisplay(secondaryTimeLabel!)
        self.tabBarItem.image = UIImage(named: "Stopwatch")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.selectedImage = UIImage(named: "Stopwatch-down")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    
    @IBAction func resetButtonClick(sender: UIButton) {
        
        if(sender.currentTitle == "Lap" )
        {
            primaryTimer.addElapsedTime()
            secondaryTimer.addLapTime()
            secondaryTimer.resetTime()
            lapTimeTableView.reloadData()
            
        }else{
            sender.setTitle("Lap", forState:.Normal)
            sender.enabled = false
            buttonStart.setTitle("Start", forState:.Normal)
            primaryTimer.resetTime()
            secondaryTimer.resetTime()
            StopWatchTimer.lapTimes.removeAll()
            lapTimeTableView.reloadData()
        }
    }
    
    
    @IBAction func startButtonClick(sender: UIButton) {
        if(sender.currentTitle == "Start" )
        {
            sender.setTitle("Stop", forState:.Normal)
            sender.setTitleColor(UIColor.redColor() , forState:.Normal)
            buttonReset.setTitle("Lap", forState:.Normal)
            primaryTimer.startTimer()
            secondaryTimer.startTimer()
            
        }else{
            sender.setTitle("Start", forState:.Normal)
            sender.setTitleColor(UIColor.greenColor() , forState:.Normal)
            buttonReset.setTitle("Reset", forState:.Normal)
            primaryTimer.stopTimer()
            secondaryTimer.stopTimer()
        }
        buttonReset.enabled = true
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return StopWatchTimer.lapTimes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! StopWatchCustomRowCell
        cell.rowLabel1.text = "Lap " + String(StopWatchTimer.lapTimes.count - indexPath.row)
        cell.rowLabel2.text = StopWatchTimer.lapTimes[indexPath.row]
        cell.rowLabel3.text = StopWatchTimer.elapsedTimes[indexPath.row]
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell" ) as! StopWatchCustomHeaderCell
        headerCell.headerLabel1.text = "Lap";
        headerCell.headerLabel2.text = "Split";
        headerCell.headerLabel3.text = "Total";
        return headerCell
    }
    
}

