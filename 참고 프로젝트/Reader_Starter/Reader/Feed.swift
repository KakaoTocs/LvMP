//
//  Feed.swift
//  Reader
//
//  Created by Jinu Kim on 30/09/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation

class Feed: NSObject {
  let name: String
  var children = [FeedItem]()
  
  init(name: String) {
    self.name = name
  }
  
  class func feedList(_ fileName: String) -> [Feed] {
    var feeds = [Feed]()
    
    if let feedList = NSArray(contentsOfFile: fileName) as? [NSDictionary] {
      for feedItems in feedList {
        let feed = Feed(name: feedItems.object(forKey: "name") as! String)
        let items = feedItems.object(forKey: "items") as! [NSDictionary]
        
        for dict in items {
          let item = FeedItem(dictionary: dict)
          feed.children.append(item)
        }
        feeds.append(feed)
      }
    }
    return feeds
  }
  
}
