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
        
        var urlString = "api.tumblr.com/v2/blog/aseaofquotes.tumblr.com/posts/photos?api_key=" + APIKey
        
        let session = NSURLSession.sharedSession()
        let quotesUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(quotesUrl!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
            }
        }
        
        task.resume()
    }
}