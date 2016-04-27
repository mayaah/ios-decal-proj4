//
//  QuotesTimelineViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/25/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

import UIKit

class QuotesTimelineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var nagivationStyleToPresent : String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var quotes : [Quote]!
    
    
    var transitionOperator = TransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        menuItem.image = UIImage(named: "Menu")
        toolbar.tintColor = UIColor.blackColor()
        
        quotes = [Quote]()
        let api = TumblrAPI()
        api.loadQuotes(didLoadQuotes)
    }
    
    func didLoadQuotes(quotes: [Quote]) {
        self.quotes = quotes
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto") as! TimelineCell
        
        let quote = quotes[indexPath.row]
            
//        cell.quoteImageView.image = UIImage(contentsOfFile: quote.photoURL)
        cell.descriptionLabel.text = quote.description
        
        asyncLoadQuoteImage(quote, imageView: cell.quoteImageView)
        cell.bookmarkImageView?.image = UIImage(named: "Bookmark")
        return cell
    }
    
    

    func asyncLoadQuoteImage(quote: Quote, imageView: UIImageView) {
        
        let downloadQueue = dispatch_queue_create("com.aseaofquotes.processdownload", nil)
        
        dispatch_async(downloadQueue) {
            
            var data = NSData(contentsOfURL: NSURL(string: quote.photoURL)!)
            
            var image : UIImage?
            if data != nil {
                quote.photoData = data
                image = UIImage(data: data!)!
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
            
        }
    }
    

}