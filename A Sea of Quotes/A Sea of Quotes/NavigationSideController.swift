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
        dismissViewControllerAnimated(true, completion: nil)
    }
}