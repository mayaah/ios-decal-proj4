//
//  QuotesTimelineViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/25/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

import UIKit

import CoreData

class QuotesTimelineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var nagivationStyleToPresent : String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var quotes : [Quote]!
    
    var savedQuotes = [NSManagedObject]()
    
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
        
        cell.bookmarkImageView.userInteractionEnabled = true
        if quote.saved == false {
            let path = NSBundle.mainBundle().pathForResource("Bookmark-64", ofType: "png")
            cell.bookmarkImageView?.image = UIImage(contentsOfFile: path!)
        } else {
            let path = NSBundle.mainBundle().pathForResource("bookmarksave", ofType: "png")
            cell.bookmarkImageView?.image = UIImage(contentsOfFile: path!)
        }
        let bmTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("bookmarkTapped:"))
        bmTapRecognizer.numberOfTapsRequired = 1
        cell.bookmarkImageView.addGestureRecognizer(bmTapRecognizer)
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
        
    }
    
    func bookmarkTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("CLICKED")
        let tappedBookmark = gestureRecognizer.view!
        var tapLocation = gestureRecognizer.locationInView(self.tableView)
        var indexPath:NSIndexPath = tableView.indexPathForRowAtPoint(tapLocation)!
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto", forIndexPath: indexPath) as! TimelineCell
        let quote = quotes[indexPath.row]
        quote.saved = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext

        let entity =  NSEntityDescription.entityForName("QuoteEntity", inManagedObjectContext:managedContext)
        
        let quoteEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        var description = quotes[indexPath.row].description
        var postURL = quotes[indexPath.row].postURL
        var photoURL = quotes[indexPath.row].photoURL
        var photoData = quotes[indexPath.row].photoData
        quoteEntity.setValue(description, forKey: "quoteDescription")
        quoteEntity.setValue(postURL, forKey: "quotePostURL")
        quoteEntity.setValue(photoURL, forKey: "quotePhotoURL")
        quoteEntity.setValue(photoData, forKey: "quoteData")
        //4
        do {
            try managedContext.save()
            //5
            savedQuotes.append(quoteEntity)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        print("BEFORE")
        let path = NSBundle.mainBundle().pathForResource("bookmarksave", ofType: "png")
        cell.bookmarkImageView?.image = UIImage(contentsOfFile: path!)
        print("AFTER")
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
//        if segue.identifier == "savedSegue" {
//            let destination = SavedQuotesViewController() // Your destination
//            self.navigationController?.pushViewController(destination, animated: true)
//        }
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