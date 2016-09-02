//
//  CustomRowTableViewCell.swift
//  StopWatch
//
//  Created by Kaustubh on 8/2/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class StopWatchCustomRowCell: UITableViewCell {

    @IBOutlet weak var rowLabel1: UILabel!
    
    @IBOutlet weak var rowLabel2: UILabel!
    
    @IBOutlet weak var rowLabel3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
