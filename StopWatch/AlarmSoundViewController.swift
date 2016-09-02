
import UIKit
import AVFoundation
import StoreKit


class AlarmSoundViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    
   
    let textCellIdentifier = "RowCell"
    
    let alarmModel:AlarmModel = AlarmModel()
    var soundPlayer:SoundPlayer = SoundPlayer()
    var alarm:Alarm?
    
    @IBOutlet weak var vibrationLabel: UILabel!
    
    
    var selectedAlarmVibration:VibrationAlarmEnum = VibrationAlarmEnum.Alert{
        didSet{
            vibrationLabel.text = alarmModel.alarmVibrationDictionary[selectedAlarmVibration]
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI(){
       selectedAlarmVibration = (alarm?.vibration)!
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section){
            case 2:
                return alarmModel.alarmRingtoneDictionary.count
            case 3:
                return 1
        default:
                return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
            case 2:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: textCellIdentifier)
                let myLabel = alarmModel.alarmRingtoneDictionary[RingtoneAlarmEnum(rawValue: indexPath.row)!]
                cell.textLabel?.text = myLabel
                if alarm!.sound == RingtoneAlarmEnum(rawValue: indexPath.row)!{
                    cell.accessoryType = .Checkmark
                }
                return cell
            case 3:
            let cell = UITableViewCell(style: .Default, reuseIdentifier:
                textCellIdentifier)
                cell.textLabel?.text = "None"
                if alarm!.sound == RingtoneAlarmEnum.None{
                    cell.accessoryType = .Checkmark
                }
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
            linkToITunesStore("id1127535876")
            return
        }
        
        if(indexPath.section == 2){
            if (alarm?.sound == RingtoneAlarmEnum.None){
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3))
                cell?.accessoryType = .None
            }else{
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: (alarm?.sound.rawValue)!, inSection: 2))
                cell?.accessoryType = .None
            }
            
            
            if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) {
                alarm?.sound = RingtoneAlarmEnum(rawValue: indexPath.row )!
                selectedRow.accessoryType = .Checkmark
                playSound(indexPath)
            }
            
            return
        }
        
        if(indexPath.section == 3){
            if(alarm?.sound != RingtoneAlarmEnum.None){
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: (alarm?.sound.rawValue)!, inSection: 2))
                cell?.accessoryType = .None
            }
      
            if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) {
                alarm?.sound = RingtoneAlarmEnum.None
                selectedRow.accessoryType = .Checkmark
                stopSound()
            }
            
        }
        
    }
    
    
    func playSound(indexPath:NSIndexPath){
        let file:String = alarmModel.alarmRingtoneDictionary[RingtoneAlarmEnum(rawValue: indexPath.row)!]!
        soundPlayer.stopSound()
        soundPlayer.playSound(file, loop: 10)
        
    }
    
    func stopSound(){
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
    
    override func viewWillDisappear(animated: Bool) {
        if let addAlarmViewController = self.navigationController?.topViewController as? AddAlarmViewController{
            addAlarmViewController.selectedAlarmSound =  (alarm?.sound)!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch(segue.identifier!){
            case "editAlarmVibrationSegue" :
            (segue.destinationViewController as? AlarmVibrationViewController)?.alarm = alarm
            break
                default:
            break
        }

    }
}
