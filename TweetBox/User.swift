//
//  User.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/17/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImgURL: NSURL?
    var tagline: String?
    var dictionary: NSDictionary?
    var favouritesCount:Int = 0
    var followersCount:Int = 0
    var followingCount:Int = 0
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileURL = dictionary["profile_image_url"] as? String
        if let profileURL = profileURL {
            profileImgURL = NSURL(string: profileURL)
        }
        self.tagline = dictionary["description"] as? String
        self.favouritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        self.followersCount = (dictionary["followers_count"] as? Int) ?? 0
        self.followingCount = (dictionary["friends_count"] as? Int) ?? 0
        
        self.dictionary = dictionary
    }
    static let UserDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let data = defaults.objectForKey("currentUser") as? NSData
                if let data = data {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                    } catch {
                        print("json desrialization error: \(error)")
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject((user.dictionary)!, options: [])
                    defaults.setObject(data, forKey: "currentUser")
                }catch {
                    print("json serialization error: \(error)")
                }
            } else {
                defaults.setObject(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
        
    }
}
