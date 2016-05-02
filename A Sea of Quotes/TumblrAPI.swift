//
//  TumblrAPI.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/24/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

class TumblrAPI {
    
    let APIKey = "MOz3EosqbGjOZHQFVmSSGwBYGicVvhiJ27Fp7Nha0Rnmf1DDbd"
    
    var quotes = [Quote]()
    
    func loadQuotes(completion: (([Quote]) -> Void)!, offset: NSInteger) {
        
        var URLString = "https://api.tumblr.com/v2/blog/aseaofquotes.tumblr.com/posts/photo?api_key=" + APIKey + "&offset=" + String(offset)
        
        let session = NSURLSession.sharedSession()
        let quotesURL = NSURL(string: URLString)
        
        var task = session.dataTaskWithURL(quotesURL!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                var error: NSError?
                
                
                
                do {
                
                    let quotesData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                
                    
                    var responseDictionary: NSDictionary!
                    responseDictionary = quotesData["response"] as! NSDictionary
                    var postsDictionary: [NSDictionary]!
                    postsDictionary = responseDictionary["posts"] as! [NSDictionary]
                    for quote in postsDictionary {
                        let quote = Quote(data: quote as NSDictionary)
                        self.quotes.append(quote)
                    
                    }
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(self.quotes)
                        }
                    }
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        }
        
        task.resume()
    }
    
    func loadSearch(completion: (([Quote]) -> Void)!, offset: NSInteger, tag: String) {
        
        var URLString = "https://api.tumblr.com/v2/blog/aseaofquotes.tumblr.com/posts/photo?api_key=" + APIKey + "&offset=" + String(offset) + "&tag=" + tag
        
        let session = NSURLSession.sharedSession()
        let quotesURL = NSURL(string: URLString)
        
        var task = session.dataTaskWithURL(quotesURL!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                var error: NSError?
                
                
                
                do {
                    
                    let quotesData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    
                    
                    var responseDictionary: NSDictionary!
                    responseDictionary = quotesData["response"] as! NSDictionary
                    var postsDictionary: [NSDictionary]!
                    postsDictionary = responseDictionary["posts"] as! [NSDictionary]
                    for quote in postsDictionary {
                        let quote = Quote(data: quote as NSDictionary)
                        self.quotes.append(quote)
                        
                    }
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(self.quotes)
                        }
                    }
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
                
            }
        }
        
        task.resume()
    }
}