//
//  SideBar.swift
//  BlurrySideBar
//
//  Created by Rey Cerio on 2016-11-25.
//  Copyright © 2016 CeriOS. All rights reserved.
//

import UIKit

//need mark @obj to protocol to specify optional requirements for methods inside protocol
@objc protocol SideBarDelegate {
    
    func sideBarDidSelectButtonAtIndex(index: Int)
    
    @objc optional func sideBarWillClose()
    @objc optional func sideBarWillOpen()
    
}

class SideBar: NSObject, SideBarTableViewControllerDelegate {
    //width of the sideBar
    let barWidth: CGFloat = 150.0
    //distance of the first item from the top of the tableView
    let sideBarTableViewTopInset: CGFloat = 64.0
    //container of the tableView (UIView that holds the actual tableView)
    let sideBarContainerView: UIView = UIView()
    //tableView for the sidebar
    let sideBarTableViewController: SideBarTableViewController = SideBarTableViewController()
    
    //subView
    var originView: UIView!
    
    //animator
    var animator: UIDynamicAnimator!
    //storage of our data (indexPath, sidebar is out or in, etc...)
    var delegate: SideBarDelegate?
    
    var isSideBarOpen:Bool = false
    
    override init() {
        super.init()
        
        
    }
    
    init(sourceView: UIView, menuItems: Array<String>){
        super.init()
        
        //initializing our variables with values
        originView = sourceView
        sideBarTableViewController.tableData = menuItems
        
        //calling the function that sets up the sideBar
        setupSideBar()
        
        //initializing animator
        animator = UIDynamicAnimator(referenceView: originView)
        
        //creating a gestureRecognizer for when you swipe left to make the sidebar come out
        let showGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(recognizer:)))
        
        //specifying the direction
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        //adding the gestureRecognizer to the subView called originView
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(recognizer:)))
        
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    func setupSideBar() {
        
        //CGRectMake is not available in Swift 3 anymore....
        sideBarContainerView.frame = CGRect(x: -barWidth - 1, y: originView.frame.origin.y, width: barWidth, height: originView.frame.size.height)
        
        sideBarContainerView.backgroundColor = UIColor.clear
        //false so that subviews are not confined to the bounds of the view
        sideBarContainerView.clipsToBounds = false
        
        originView.addSubview(sideBarContainerView)
        
        //adding a blurView, Adding it before the TableView so its under it in the View
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        //adding the tableView
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        //no separator
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        sideBarTableViewController.tableView.backgroundColor = UIColor.clear
        //disable scrolling to top, scroll down if too many items on table...
        sideBarTableViewController.tableView.scrollsToTop = false
        //separating the cells by same amount as the top inset
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        //reloading our tableView
        sideBarTableViewController.tableView.reloadData()
        //adding the sidebar to the sideBarContainerView
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
        
    }
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer){
        
        if recognizer.direction == UISwipeGestureRecognizerDirection.left {
            
            showSideBar(shouldOpen: false)
            delegate?.sideBarWillClose?()
            
        } else {
            
            showSideBar(shouldOpen: true)
            delegate?.sideBarWillOpen?()
        }
        
    }
    
    func showSideBar(shouldOpen:Bool){
        
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        //**ANIMATION**
        //new type of IF STATEMENT reading ((if (shouldOpen) ? value of true : value of false) : is the else)
        //gravity in x direction (speed of opening and closing)
        let gravityX:CGFloat = (shouldOpen) ? 0.5 : -0.5
        //magnitude is the bounce
        let magnitude: CGFloat = (shouldOpen) ? 20 : -20
        //boundary that stops the menu from sliding past
        let boundaryX: CGFloat = (shouldOpen) ? barWidth : -barWidth - 1
        
        
        //adding behaviour to our menu
        //items is the view that we want to animate
        let gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        //gravity direction using CGVectorMask
        gravityBehaviour.gravityDirection = CGVector(dx: gravityX, dy: 0)
        //adding the behaviour
        animator.addBehavior(gravityBehaviour)
        
        //collision behaviour
        let collisionBehaviour: UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        //setting up where the collision will happen (collision with boundaryX)
        collisionBehaviour.addBoundary(withIdentifier: "sideBarBoundary" as NSCopying, from: CGPoint(x: boundaryX, y: 20), to: CGPoint(x: boundaryX, y: originView.frame.size.height))
        //adding behaviour
        animator.addBehavior(collisionBehaviour)
        
        //Push Behaviour with magnitude
        let pushBehaviour: UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehaviour.magnitude = magnitude
        animator.addBehavior(pushBehaviour)
        
        //adding DYNAMIC behaviour
        let sideBarBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        //more elasticity, more bouncy
        sideBarBehaviour.elasticity = 0.3
        animator.addBehavior(sideBarBehaviour)
        
        
    }
    
    //this func is necessary to conform with SideBarTableViewControllerDelegate type
    func sideBarControlDidSelectRow(indexPath:NSIndexPath){
        
        delegate?.sideBarDidSelectButtonAtIndex(index: indexPath.row)
        
    }

}
