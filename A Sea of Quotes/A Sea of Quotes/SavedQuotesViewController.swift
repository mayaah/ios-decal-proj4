//
//  SavedQuotesViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/29/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

import CoreData

import UIKit
class SavedQuotesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    var nagivationStyleToPresent : String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var transitionOperator = TransitionOperator()
    
    var savedQuotes = [NSManagedObject]()
    
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "QuoteEntity")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            savedQuotes = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedQuotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto", forIndexPath: indexPath) as! TimelineCell
        
        let quote = savedQuotes[indexPath.row]
        
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
        cell.descriptionLabel.text = quote.valueForKey("quoteDescription") as? String
        cell.descriptionLabel.preferredMaxLayoutWidth = (tableView.bounds.width - 75)
        let photoData = quote.valueForKey("quoteData") as? NSData
        
        asyncLoadQuoteImage(photoData!, imageView: cell.quoteImageView)
        
//        cell.quoteImageView.userInteractionEnabled = true
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
//        tapRecognizer.numberOfTapsRequired = 2
//        cell.quoteImageView.addGestureRecognizer(tapRecognizer)
        
        cell.bookmarkImageView.userInteractionEnabled = true
        cell.bookmarkImageView?.image = UIImage(named: "bookmarksave")
        let bmTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("bookmarkTapped:"))
        bmTapRecognizer.numberOfTapsRequired = 1
        cell.bookmarkImageView.addGestureRecognizer(bmTapRecognizer)
        return cell
    }
    
    func bookmarkTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("CLICKED")
        let tappedBookmark = gestureRecognizer.view!
        var tapLocation = gestureRecognizer.locationInView(self.tableView)
        var indexPath:NSIndexPath = tableView.indexPathForRowAtPoint(tapLocation)!
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto", forIndexPath: indexPath) as! TimelineCell
        let quote = savedQuotes[indexPath.row]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        // 3
        moc.deleteObject(savedQuotes[indexPath.row])
        appDelegate.saveContext()
        
        // 4
        savedQuotes.removeAtIndex(indexPath.row)
        tableView.reloadData()
    }

    
    func asyncLoadQuoteImage(photoData: NSData, imageView: UIImageView) {
        
        let downloadQueue = dispatch_queue_create("com.aseaofquotes.processdownload", nil)

            
        dispatch_async(downloadQueue) {
                
            var image : UIImage?
            image = UIImage(data: photoData)!

            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
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


    
    
    
    
    
    
    
    
    
}
