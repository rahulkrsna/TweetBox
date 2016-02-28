//
//  ReplyToTweetViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/26/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
import AFNetworking
let MAX_TWEET_SIZE:Int = 140

class ReplyToTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userHandleLabel: UILabel!
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var tweetSizeLabel: UILabel!
    @IBOutlet var tweetsViewBtn: UIButton!
    
    var tweetInfo: ReplyTweetUserInfo!
    var tweetIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigationBar background colour
        navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 153.0/255.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tweetTextView.delegate = self
        self.tweetsViewBtn.hidden = true
        
        fillTweetInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        let alertController = UIAlertController(title: "Tweet", message: "Successful", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction) -> Void in
            self.performSegueWithIdentifier("tweetToTweetsViewSegue", sender: nil)
        }
        alertController.addAction(OKAction)
        
        // Reply to User only in case of reply tweet
        var replyToUser = ""
        if(!tweetInfo.newTweet) {
            replyToUser = self.tweetInfo.userHandle!
        }
        
        if self.tweetTextView.text.characters.count > 0 {
            TwitterClient.sharedInstance.replyToTweet(self.tweetTextView.text, replytoUser: replyToUser, success: { () -> () in
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    //Tweet Successful
                })
            }, failure: { () -> () in
                print("Tweet Failed")
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                })
            })
        }
    }
    
    func fillTweetInformation() {
        
        if let tweetInfo = self.tweetInfo {
            if let url = tweetInfo.userProfileURL {
                self.userImageView.setImageWithURL(url)
            }
            self.userNameLabel.text = tweetInfo.userName!
            self.userHandleLabel.text = "@\(tweetInfo.userHandle!)"
        }
        // In case it is a reply tweet
        self.tweetTextView.text = ""
        self.tweetSizeLabel.text = "\(MAX_TWEET_SIZE)"
        if !tweetInfo.newTweet {
            if  (self.tweetInfo.userHandle!.characters.count) <= MAX_TWEET_SIZE  && self.tweetInfo.userHandle!.characters.count > 0 {
                self.tweetTextView.text = self.userHandleLabel.text
                self.tweetSizeLabel.text = "\(MAX_TWEET_SIZE - (self.userHandleLabel.text?.characters.count)!)"
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        
        var lengthOfTweet = MAX_TWEET_SIZE - textView.text.characters.count
        
        if (lengthOfTweet <= 0) {
            self.tweetTextView.text = self.tweetTextView.text[self.tweetTextView.text.startIndex ... self.tweetTextView.text.startIndex.advancedBy(MAX_TWEET_SIZE-1)]
            lengthOfTweet = 0
        }
        self.tweetSizeLabel.text = "\(lengthOfTweet)"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
