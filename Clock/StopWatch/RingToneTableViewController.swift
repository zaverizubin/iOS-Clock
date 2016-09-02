//
//  RingtoneTableViewController.swift
//  StopWatch
//
//  Created by Kaustubh on 8/10/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit


class RingToneTableViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    
    var ringtone:String = ""
    
    let textCellIdentifier2 = "RingtoneRowCell2"
    
    let ringtones = RingtoneModel().ringtones
    
    var soundPlayer:SoundPlayer = SoundPlayer()
    
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch(section){
            case 0, 2:
                return super.tableView(tableView, numberOfRowsInSection: section)
            default:
                return ringtones.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        switch(indexPath.section){
        case 0:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            
        case 1:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: textCellIdentifier2)
            cell.textLabel?.text = ringtones[indexPath.row]
            if ringtones[indexPath.row] == ringtone{
                    cell.accessoryType = .Checkmark
            }else{
                cell.accessoryType = .None
            }
            
            return cell
       
        default:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50

    }
    
    
    
    override
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
        
        if(indexPath.section == 0){
            linkToITunesStore("id1127535876")
            return
        }
        
        if(indexPath.section == 1){
            
            if let index = ringtones.indexOf(ringtone) {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1))
                cell?.accessoryType = .None
            }
            
            if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) {
                ringtone = ringtones[indexPath.row]
                selectedRow.accessoryType = .Checkmark
                playSound(indexPath)
            }
            
            return
        }
        
        if(indexPath.section == 2){
            stopSound()
        }
        
    }
    
    
    func  playSound(indexPath:NSIndexPath){
        let file:String = ringtones[indexPath.row]
        soundPlayer.stopSound()
        soundPlayer.playSound(file)
    }
    
    func  stopSound(){
        soundPlayer.stopSound()
    }
    
    func linkToITunesStore(identifier:String){
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        self.presentViewController(storeViewController, animated: true, completion: nil)
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProductWithParameters(parameters) {
            [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.presentViewController(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
