//
//  InfoViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 5/1/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

class InfoViewController : UIViewController {
    var nagivationStyleToPresent : String?
    

    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
}
