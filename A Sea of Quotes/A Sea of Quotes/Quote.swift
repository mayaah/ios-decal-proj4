//
//  Quote.swift
//  A Sea of Quotes
//
//  Created by Maya Angelica  on 4/24/16.
//  Copyright © 2016 mayaah. All rights reserved.
//

import Foundation

class Quote {
    
    var description : String!
    var postURL : String!
    var photoURL : String!
    
    init(data : NSDictionary) {
        
        let desc = getStringFromJSON(data, key: "summary")
        self.description = desc
        
        let post = getStringFromJSON(data, key: "post_url")
        self.postURL = post
        
        let photos = data["photos"] as! NSDictionary
        let origSize = photos["original_size"] as! NSDictionary
        self.photoURL = getStringFromJSON(origSize, key: "url")
    }
    
    func getStringFromJSON(data: NSDictionary, key: String) -> String {
        
        if let info = data[key] as? String {
            return info
        }
        
        return ""
    }
}