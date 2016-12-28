//
//  SideBarTableViewController.swift
//  BlurrySideBar
//
//  Created by Rey Cerio on 2016-11-25.
//  Copyright © 2016 CeriOS. All rights reserved.
//

import UIKit

//protocol that will tell us which cell of the tableView was pressed
protocol SideBarTableViewControllerDelegate {
    //function that will return the indexPath.row of the selected cell
    func sideBarControlDidSelectRow(indexPath:NSIndexPath)
    
}

class SideBarTableViewController: UITableViewController {
    
    //tableView delegate var
    var delegate: SideBarTableViewControllerDelegate?
    //dataSource of the tableView
    var tableData: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //changing it to var because were doing this programmatically
        //no indexPath
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!

        if cell == nil{
            
            //initializing the cell if its nil
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            // Configure the cell...
            //adding a blurry effect on the background
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.darkText
            //adding the highlighted version of cell when selected
            let selectedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            //adding the selected version of the cell into it
            cell!.selectedBackgroundView = selectedView
        }
        
        cell!.textLabel?.text = tableData[indexPath.row]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height of the rows
        return 45.0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //sending the indexPath to the delegate protocol
        delegate?.sideBarControlDidSelectRow(indexPath: indexPath as NSIndexPath)
        
    }
    
}
