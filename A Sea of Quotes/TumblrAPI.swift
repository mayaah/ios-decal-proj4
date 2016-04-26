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
    
    func loadQuotes(completion: ((AnyObject) -> Void)!) {
        
        var URLString = "api.tumblr.com/v2/blog/aseaofquotes.tumblr.com/posts/photos?api_key=" + APIKey
        
        let session = NSURLSession.sharedSession()
        let quotesURL = NSURL(string: URLString)
        
        var task = session.dataTaskWithURL(quotesURL!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                var error: NSError?
                
                var quotes = [Quote]()
                
                do {
                
                    let quotesData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                
                
                    for quote in quotesData {
                        let quote = Quote(data: quote as! NSDictionary)
                        quotes.append(quote)
                    }
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(quotes)
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