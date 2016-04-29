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
    
    var offset: Int = 0
    
    var cache = NSCache()
    
    let api = TumblrAPI()
    
    
    var transitionOperator = TransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        menuItem.image = UIImage(named: "Menu")
        // toolbar.tintColor = UIColor.blackColor()
        
        quotes = [Quote]()
        
        api.loadQuotes(didLoadQuotes, offset: offset)
        
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    
    func didLoadQuotes(quotes: [Quote]) {
        self.quotes = quotes
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto", forIndexPath: indexPath) as! TimelineCell
        
        let quote = quotes[indexPath.row]
            
//        cell.quoteImageView.image = UIImage(contentsOfFile: quote.photoURL)
        
//        var descriptionText = quote.description
//        var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: descriptionText)
//        var commaIndex = 0
//        for i in descriptionText.characters {
//            while i != "," {
//                commaIndex += 1
//            }
//        }
//        attributedText.addAttributes([NSFontAttributeName: UIFont.italicSystemFontOfSize(14)], range: NSRange(location: commaIndex, length: descriptionText.characters.count))
        cell.descriptionLabel.text = quote.description
        cell.descriptionLabel.preferredMaxLayoutWidth = (tableView.bounds.width - 75)
        
        asyncLoadQuoteImage(quote, imageView: cell.quoteImageView)
        cell.quoteImageView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        tapRecognizer.numberOfTapsRequired = 2
        cell.quoteImageView.addGestureRecognizer(tapRecognizer)
        
        
        cell.bookmarkImageView?.image = UIImage(named: "Bookmark")
        return cell
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view!
        var tapLocation = gestureRecognizer.locationInView(self.tableView)
        
        var indexPath:NSIndexPath = tableView.indexPathForRowAtPoint(tapLocation)!
        
        var postURL = quotes[indexPath.row].postURL
        
        UIApplication.sharedApplication().openURL(NSURL(string: postURL)!)
        
        

        print("Single Tap on imageview")
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row+1 == quotes.count {
            offset += 20
            api.loadQuotes(didLoadQuotes, offset: offset)
        }
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
    
    
    func asyncLoadQuoteImage(quote: Quote, imageView: UIImageView) {
        
        let downloadQueue = dispatch_queue_create("com.aseaofquotes.processdownload", nil)
        
        let image = cache.objectForKey(quote) as? UIImage
        
        if image == nil {
        
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
        } else {
            imageView.image = image
        }
    }
    

}