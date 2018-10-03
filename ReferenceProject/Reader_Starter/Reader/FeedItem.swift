//
//  FeedItem.swift
//  Reader
//
//  Created by Jinu Kim on 30/09/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation

class FeedItem: NSObject {
  let url: String
  let title: String
  let publishingDate: Date
  
  init(dictionary: NSDictionary) {
    self.url = dictionary.object(forKey: "url") as! String
    self.title = dictionary.object(forKey: "title") as! String
    self.publishingDate = dictionary.object(forKey: "date") as! Date
  }
}
