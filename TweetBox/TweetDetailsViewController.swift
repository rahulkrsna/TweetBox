//
//  TweetDetailsViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/26/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailsViewController: UIViewController {

    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userHandleLabel: UILabel!
    @IBOutlet var tweetDescriptionLabel: UILabel!
    @IBOutlet var tweetDateLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favouritesCountLabel: UILabel!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var replyToTweetButton: UIButton!
    
    var tweet: Tweet!
    var tweetIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigationBar background colour
        navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 153.0/255.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        fillTweetInformation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        let retweetBtn = sender as! UIButton
        let tweetId = TWEETS![self.tweetIndex].tweetId
        
        if TWEETS![retweetBtn.tag].retweeted == false {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onRetweeted(tweetId, success: { (status: Bool) -> () in
                    TWEETS![self.tweetIndex].retweeted = true
                    TWEETS![self.tweetIndex].retweetCount += 1
                    self.setRetweetedTo(status)
                    self.retweetCountLabel.text = "\(TWEETS![self.tweetIndex].retweetCount)"
                    }) { () -> () in
                        print("Can't do a Retweet")
                }
            }
        } else {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onUnRetweeted(tweetId, success: { (status: Bool) -> () in
                    TWEETS![self.tweetIndex].retweeted = false
                    TWEETS![self.tweetIndex].retweetCount -= 1
                    self.setRetweetedTo(status)
                    self.retweetCountLabel.text = "\(TWEETS![self.tweetIndex].retweetCount)"
                    }) { () -> () in
                        print("Can't do an undo Retweet")
                }
            }
        }
    }
    
    @IBAction func onFavourite(sender: AnyObject) {
        
        let favouriteBtn = sender as! UIButton
        let tweetId = TWEETS![favouriteBtn.tag].tweetId
        
        if TWEETS![favouriteBtn.tag].favourited == false {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onFavourited(tweetId, success: { (status: Bool) -> () in
                    
                    TWEETS![self.tweetIndex].favourited = true
                    TWEETS![self.tweetIndex].user?.favouritesCount += 1
                    self.setFavouritedTo(true)
                    self.favouritesCountLabel.text = "\(TWEETS![self.tweetIndex].user!.favouritesCount)"
                    }) { () -> () in
                        print("Can't favourite the tweet")
                }
            }
        } else {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onUnFavourited(tweetId, success: { (status: Bool) -> () in
                    
                    TWEETS![self.tweetIndex].favourited = false
                    TWEETS![self.tweetIndex].user?.favouritesCount -= 1
                    self.setFavouritedTo(status)
                    self.favouritesCountLabel.text = "\(TWEETS![self.tweetIndex].user!.favouritesCount)"
                    }) { () -> () in
                        print("Can't unfavourite the tweet")
                }
            }
        }
    }
    
    func setFavouritedTo(status:Bool) {
        if status {
            self.favouriteButton.setBackgroundImage(UIImage(named: "favourite-on-24"), forState: UIControlState.Normal)
        } else {
            self.favouriteButton.setBackgroundImage(UIImage(named: "favourite-off-24"), forState: UIControlState.Normal)
        }
    }
    
    func setRetweetedTo(status:Bool) {
        if(status) {
            self.retweetButton.setBackgroundImage(UIImage(named:"retweet-on-16"), forState: UIControlState.Normal)
        } else {
            self.retweetButton.setBackgroundImage(UIImage(named:"retweet-off-24"), forState: UIControlState.Normal)
        }
    }
    
    func fillTweetInformation() {
        
        if let tweet = self.tweet {
            
            self.tweetDescriptionLabel.text = tweet.text!.stringByRemovingPercentEncoding
            
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if let date = tweet.createdAt {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/YY "
                self.tweetDateLabel.text = dateFormatter.stringFromDate(date)
            }
            
            if let user = tweet.user {
                if let url = user.profileImgURL {
                    self.userProfileImage.setImageWithURL(url)
                }
                self.userNameLabel.text = user.name!
                self.userHandleLabel.text = "@\(user.screenName!)"
                self.favouritesCountLabel.text = "\(user.favouritesCount)"
            }
            
            setFavouritedTo(tweet.favourited)
            setRetweetedTo(tweet.retweeted)
            
        } else {
            
            self.tweetDescriptionLabel.text = "Tweet Description not available!"
            self.retweetButton.hidden = true
            self.favouriteButton.hidden = true
            self.replyToTweetButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let replyToTweetViewController = segue.destinationViewController as! ReplyToTweetViewController
        replyToTweetViewController.tweetIndex = self.tweetIndex
        replyToTweetViewController.tweet = TWEETS![self.tweetIndex]
    }

}
