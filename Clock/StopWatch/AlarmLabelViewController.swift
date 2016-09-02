//
//  AlarmLabelController.swift
//  StopWatch
//
//  Created by Mac Moham on 30/08/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class AlarmLabelViewController: UIViewController , UITextFieldDelegate{
    
    
    @IBOutlet weak var alarmTextField: UITextField!
    
    var alarmLabel:String = ""
    
    
    override func viewDidLoad() {
        alarmTextField.delegate = self
        alarmTextField.text = alarmLabel
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let addAlarmViewController = self.navigationController?.topViewController as? AddAlarmViewController{
            
            if alarmTextField.text != ""{
                addAlarmViewController.alarmLabel.text = alarmTextField.text
            }
        }
    }

    
}
