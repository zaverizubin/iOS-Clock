//
//  ClockTabViewController.swift
//  Timer
//
//  Created by Mac Moham on 01/09/16.
//  Copyright © 2016 Focalworks. All rights reserved.
//

import UIKit

class ClockTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI(){
       
        
        
        self.tabBar.items![0].image = UIImage(named: "Alarm")?.imageWithRenderingMode(UIImageRenderingMode.Automatic)
        self.tabBar.items![0].selectedImage = UIImage(named: "Alarm-down")?.imageWithRenderingMode(UIImageRenderingMode.Automatic)
        
        self.tabBar.items![1].image = UIImage(named: "Stopwatch")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(named: "Stopwatch-down")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.tabBar.items![1].image = UIImage(named: "Timer")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(named: "Timer-down")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

    }
    

}
