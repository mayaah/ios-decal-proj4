//
//  SearchViewController.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 5/1/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class SearchViewController : UIViewController, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource {
    
    
    var nagivationStyleToPresent : String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var transitionOperator = TransitionOperator()
    
    var taggedQuotes : [Quote]!
    
    var savedQuotes = [NSManagedObject]()
    
    var offset: Int = 0
    
    let api = TumblrAPI()
    
    var searchController: UISearchController!
    var searchString : String!
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        configureSearchController()
        self.navigationController?.navigationBarHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        menuItem.image = UIImage(named: "Menu")
        
        taggedQuotes = [Quote]()
        print("TAGGEDQUOTES")
        print(taggedQuotes)
        
        
        
    }
    
    @IBAction func presentNavigation(sender: AnyObject?){
        
        if self.nagivationStyleToPresent != nil {
            transitionOperator.transitionStyle = nagivationStyleToPresent!
            self.performSegueWithIdentifier(nagivationStyleToPresent!, sender: self)
        }
    }
    
    func didLoadQuotes(quotes: [Quote]) {
        print("1")
        self.taggedQuotes = quotes
        print(taggedQuotes)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taggedQuotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("2")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto", forIndexPath: indexPath) as! TimelineCell
        
        
        let quote = taggedQuotes[indexPath.row]
        

        cell.descriptionLabel.text = quote.description
        cell.descriptionLabel.preferredMaxLayoutWidth = (tableView.bounds.width - 75)
        
        asyncLoadQuoteImage(quote, imageView: cell.quoteImageView)
        cell.quoteImageView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        tapRecognizer.numberOfTapsRequired = 2
        cell.quoteImageView.addGestureRecognizer(tapRecognizer)
        
        cell.bookmarkImageView.userInteractionEnabled = true
        let path = NSBundle.mainBundle().pathForResource("Bookmark-64", ofType: "png")
        cell.bookmarkImageView?.image = UIImage(contentsOfFile: path!)
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
        
        var postURL = taggedQuotes[indexPath.row].postURL
        
        UIApplication.sharedApplication().openURL(NSURL(string: postURL)!)
        
    }
    
    func bookmarkTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("CLICKED")
        let tappedBookmark = gestureRecognizer.view!
        var tapLocation = gestureRecognizer.locationInView(self.tableView)
        var indexPath:NSIndexPath = tableView.indexPathForRowAtPoint(tapLocation)!
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto", forIndexPath: indexPath) as! TimelineCell
        let quote = taggedQuotes[indexPath.row]
        quote.saved = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("QuoteEntity", inManagedObjectContext:managedContext)
        
        let quoteEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        var description = taggedQuotes[indexPath.row].description
        var postURL = taggedQuotes[indexPath.row].postURL
        var photoURL = taggedQuotes[indexPath.row].photoURL
        var photoData = taggedQuotes[indexPath.row].photoData
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
        print("3")
        if indexPath.row+1 == taggedQuotes.count {
            offset += 20
            api.loadSearch(didLoadQuotes, offset: offset, tag: searchString, newSearch: false)
        }
    }


    
    
    func configureSearchController() {
        print("4")
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        shouldShowSearchResults = false
//        tableView.reloadData()
//    }
    
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("5")
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("6")
        let newSearchString = searchController.searchBar.text
        if newSearchString != searchString {
            taggedQuotes = [Quote]()
            print(taggedQuotes)
        }
        searchString = newSearchString
//        if !shouldShowSearchResults {
//            shouldShowSearchResults = true
        api.loadSearch(didLoadQuotes, offset: offset, tag: searchString, newSearch: true)
            tableView.reloadData()
//            
//        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("7")
        if shouldShowSearchResults {
        
        print("SEAERCHSTRING:")
        print(searchString)
        
        
        // Reload the tableview.
        tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as UIViewController!
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator

    }
    
    func asyncLoadQuoteImage(quote: Quote, imageView: UIImageView) {
        print("8")
        
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
