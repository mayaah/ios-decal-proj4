//
//  InfoViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 5/1/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController : UIViewController {
    var nagivationStyleToPresent : String?
    var transitionOperator = TransitionOperator()
    
    
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        menuItem.image = UIImage(named: "Menu")
    }
    
    @IBAction func presentNavigation(sender: AnyObject?){
        
        if self.nagivationStyleToPresent != nil {
            transitionOperator.transitionStyle = nagivationStyleToPresent!
            self.performSegueWithIdentifier(nagivationStyleToPresent!, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as UIViewController!
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
    }

}
