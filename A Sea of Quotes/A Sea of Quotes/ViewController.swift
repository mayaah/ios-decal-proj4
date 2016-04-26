//
//  ViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/24/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = TumblrAPI()
        api.loadQuotes(nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

