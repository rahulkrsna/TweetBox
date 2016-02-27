//
//  TwitterClient.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/15/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "MTZY4aksYUKwMtXHFpGscGPS4"
let twitterConsumerSecret = "WfoaK2L9iNVrA40tSRpfhU2YXPfRHBK9SNCfrEZM6nChuIpNtB"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess : (( ) -> ())?
    var loginFailure: ((NSError) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(success: (() -> ()), failure: ((NSError) -> ())) {
        
        loginSuccess = success
        loginFailure = failure
        
        // Remove the access token
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        // Get the Access token
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                
                let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Failed to get a request token")
                self.loginFailure!(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.UserDidLogoutNotification, object: nil)
    }
    
    // Get the User Account Details
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
            
        //GET Current User
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: { (progress: NSProgress) -> Void in
        }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error in getting the current user")
            failure(error)
        })
    }
    
    // Get the Tweets for the current user from the home timeline
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        //GET the timeline of tweets
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            })
    }
    
    // Get the Tweets for the current user from the home timeline
    func homeTimelineSinceId(sinceId: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        let params:[String: AnyObject] = ["since_id": sinceId]
        
        //GET the timeline of tweets since an ID
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func handleOpenURL(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //Saving the access Token.
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess!()
            }, failure: { (error: NSError) -> () in
                self.loginFailure!(error)
            })
                self.loginSuccess!()
            }) { (error: NSError!) -> Void in
                print("Unable to get the access Token: \(error.description)")
                self.loginFailure!(error)
        }
    }
    
    func onFavourited(tweetId: String, success: (Bool)->(), failure: ()->() ) {
        
        var params = [String: AnyObject]()
        params["id"] = tweetId
        
        //POST Favourited Tweet
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json", parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                success(true)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
        }
    }
    
    func onUnFavourited(tweetId: String, success: (Bool)->(), failure: ()->() ) {
        
        var params = [String: AnyObject]()
        params["id"] = tweetId
        
        //POST Favourited Tweet
        TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json", parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                success(false) // false means removed from favourtie
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
        }
    }
    
    func onRetweeted( tweetId: String, success: (Bool) -> (), failure: ()->()) {
        
        //POST Retweet Tweet
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: { (progress: NSProgress) -> Void in
            }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                success(true)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure()
        }
    }
    
    func onUnRetweeted(tweetId: String, success: (Bool) -> (), failure: () -> ()) {
        
        //POST unRetweet a Tweet
        TwitterClient.sharedInstance.POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: { (progress: NSProgress) -> Void in
        }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success(false) // false means removed from retweet
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure()
        }
    }
    
    func replyToTweet(text: String, replytoUser: String, success:() -> (), failure: () -> ()) {
        
        var params = [String: AnyObject]()
        params["status"] = text
        
        if replytoUser.characters.count > 0 {
            params["in_reply_to_status_id"] = replytoUser
        }
        
        print(params)
        
        //POST Reply To Tweet
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                success()
            }) { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                print("error: \(error.localizedDescription)")
                failure()
        }
    }
}
