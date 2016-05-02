//
//  NavigationSideController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/27/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation
import UIKit

class NavigationSideController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var tableView   : UITableView!
    @IBOutlet var dimmerView  : UIView!
    
    var icons : [String]!
    
    var pushClosure:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        bgImageView.image = UIImage(named: "sea-bg")
//        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        icons = ["quotesicon", "searchicon", "bookmarkwhiteicon", "infoicon"]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationSideCell") as! NavigationSideCell
        
        let icon = icons[indexPath.row]
        cell.iconImageView.image = UIImage(named: icon)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == 0 {
//            dismissViewControllerAnimated(true, completion: nil)
//        } else if indexPath.row == 2 {
//            print("here yo")
//            let destination = SavedQuotesViewController() // Your destination
//            print(QuotesTimelineViewController().navigationController)
//            QuotesTimelineViewController().navigationController?.pushViewController(destination, animated: true)
//             performSegueWithIdentifier("SavedQuotesIdentifier", sender: AnyObject!)
//        }
        
//        dismissViewControllerAnimated(true, completion: nil)
        
//        if indexPath.row == 2{
//            QuotesTimelineViewController().performSegueWithIdentifier("savedQuotesSegue", sender: self)
//        }
//        let row = indexPath.row
//        var navScreenIdentifer = ""
//        if (row == 2) {
//            navScreenIdentifer = ""
//        }
//
//        let vc : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier(navScreenIdentifer)
//        self.showViewController(vc as! UIViewController, sender: vc)
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // make sure to set storyboard id in storyboard for these VC
            let startingVC =  storyboard.instantiateViewControllerWithIdentifier("QuotesTimelineViewController");
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.navController.viewControllers = [startingVC]
            dismissViewControllerAnimated(true, completion: nil)
        }
        if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // make sure to set storyboard id in storyboard for these VC
            let startingVC =  storyboard.instantiateViewControllerWithIdentifier("SavedQuotesViewController");
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.navController.viewControllers = [startingVC]
            dismissViewControllerAnimated(true, completion: nil)
        }
        

        
    }
}