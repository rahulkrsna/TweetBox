//
//  Tweet.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/17/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favourited = false
    var retweeted = false
    var tweetId: String?
    
    init(dictionary: NSDictionary) {
        self.tweetId = dictionary["id_str"] as? String
        self.user = User(dictionary: dictionary["user"] as! NSDictionary)
        self.text = dictionary["text"] as? String
        
        let createdAtString = dictionary["created_at"] as? String
        if let createdAtString = createdAtString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.createdAt = formatter.dateFromString(createdAtString)
        }
        
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favourited = (dictionary["favorited"] as? Bool)!
        self.retweeted = (dictionary["retweeted"] as? Bool)!
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        
        return tweets
    }
}
