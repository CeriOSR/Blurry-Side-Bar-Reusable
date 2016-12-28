//
//  ViewController.swift
//  BlurrySideBar
//
//  Created by Rey Cerio on 2016-11-25.
//  Copyright © 2016 CeriOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideBarDelegate {
    
    var sideBar: SideBar = SideBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["First Item", "Second Item", "Third Item"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //***** func needed to conform with SideBarDelegate Type *******
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
    }


}

