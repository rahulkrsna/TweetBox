//
//  TweetCell.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/19/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var thumbImgView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var retweetedLabel: UILabel!
    @IBOutlet var retweetedImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userHandleLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var forwardTweetButton: UIButton!
    @IBOutlet var onRetweet: UIButton!
    @IBOutlet var retweetsLabel: UILabel!
    @IBOutlet var favouritesLabel: UILabel!
    
    
//    extension String {
//        init(htmlEncodedString: String) {
//            let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
//            let attributedOptions : [String: AnyObject] = [
//                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
//            ]
//            let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
//            self.init(attributedString.string)
//        }
//    }
    
    var tweet: Tweet! {
        didSet {

            self.tweetLabel.text = tweet.text!.stringByRemovingPercentEncoding
            
            self.retweetsLabel.text = "\(tweet.retweetCount)"
            
            if let date = tweet.createdAt {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/YYYY"
                self.createdAtLabel.text = dateFormatter.stringFromDate(date)
            }
            
            if let user = tweet.user {
                if let url = user.profileImgURL {
                    self.thumbImgView.setImageWithURL(url)
                }
                self.usernameLabel.text = user.name!
                self.userHandleLabel.text = "@\(user.screenName!)"
                self.favouritesLabel.text = "\(user.favouritesCount)"
            }
            
            setFavouritedTo(tweet.favourited)
            setRetweetedTo(tweet.retweeted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImgView.layer.cornerRadius = 3
        thumbImgView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavourite(sender: AnyObject) {
        
        let favouriteBtn = sender as! UIButton
        let tweetId = TWEETS![favouriteBtn.tag].tweetId
        
        if TWEETS![favouriteBtn.tag].favourited == false {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onFavourited(tweetId, success: { (status: Bool) -> () in
                    
                    TWEETS![favouriteBtn.tag].favourited = true
                    TWEETS![favouriteBtn.tag].user?.favouritesCount += 1
                    self.setFavouritedTo(true)
                    self.favouritesLabel.text = "\(TWEETS![favouriteBtn.tag].user!.favouritesCount)"
                }) { () -> () in
                    print("Can't favourite the tweet")
                }
            }
        } else {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onUnFavourited(tweetId, success: { (status: Bool) -> () in
                    
                    TWEETS![favouriteBtn.tag].favourited = false
                    TWEETS![favouriteBtn.tag].user?.favouritesCount -= 1
                    self.setFavouritedTo(status)
                    self.favouritesLabel.text = "\(TWEETS![favouriteBtn.tag].user!.favouritesCount)"
                }) { () -> () in
                    print("Can't unfavourite the tweet")
                }
            }
        }
    }
    
    @IBAction func onForward(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        let retweetBtn = sender as! UIButton
        let tweetId = TWEETS![retweetBtn.tag].tweetId
        
        if TWEETS![retweetBtn.tag].retweeted == false {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onRetweeted(tweetId, success: { (status: Bool) -> () in
                    TWEETS![retweetBtn.tag].retweeted = true
                    TWEETS![retweetBtn.tag].retweetCount += 1
                    self.setRetweetedTo(status)
                    self.retweetsLabel.text = "\(TWEETS![retweetBtn.tag].retweetCount)"
                }) { () -> () in
                    print("Can't do a Retweet")
                }
            }
        } else {
            if let tweetId = tweetId {
                TwitterClient.sharedInstance.onUnRetweeted(tweetId, success: { (status: Bool) -> () in
                    TWEETS![retweetBtn.tag].retweeted = false
                    TWEETS![retweetBtn.tag].retweetCount -= 1
                    self.setRetweetedTo(status)
                    self.retweetsLabel.text = "\(TWEETS![retweetBtn.tag].retweetCount)"
                }) { () -> () in
                    print("Can't do an undo Retweet")
                }
            }
        }
    }
    
    func setFavouritedTo(status:Bool) {
        
        if status {
            self.favoriteButton.imageView?.image = UIImage(named: "favorite-on-16")
        } else {
            self.favoriteButton.imageView?.image = UIImage(named: "favorite-off-16")
        }
    }
    
    func setRetweetedTo(status:Bool) {
        if(status) {
            self.onRetweet.imageView?.image = UIImage(named: "retweet-on-16")
        } else {
            self.onRetweet.imageView?.image = UIImage(named: "retweet-off-16")
        }
    }
    
}
