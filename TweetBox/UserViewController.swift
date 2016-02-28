//
//  UserViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/20/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
import AFNetworking

class UserViewController: UIViewController { //, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var titleItem: UINavigationItem!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var userHandleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigationBar background colour
        navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 153.0/255.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName :UIColor.whiteColor() ]
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.estimatedRowHeight = 150
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
//        userImageView.layer.cornerRadius = userImageView.bounds.width/2
//        userImageView.layer.masksToBounds = true
//        userImageView.layer.borderWidth = 2
//        userImageView.clipsToBounds = true
        
        userImageView.layer.cornerRadius = 6
        userImageView.layer.borderWidth = 2
        userImageView.clipsToBounds = true
        
        fillUserDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillUserDetails() {
        
        let user = User.currentUser!
    
//        if let name = user.screenName {
//            self.titleItem.title = "@\(name)"
//        }
        
        if let name = user.screenName {
            self.userHandleLabel.text = "@\(name)"
        }
        
        if let name = user.name {
            self.userNameLabel.text = name
        }
        
        self.followersCountLabel.text = "\(user.followersCount)"
        self.followingCountLabel.text = "\(user.followingCount)"
        
        if let url = user.profileImgURL {
            self.userImageView.setImageWithURL(url)
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        print(indexPath.row)
        Cell.tweet = TWEETS![indexPath.row]
        Cell.retweetButton.tag = indexPath.row
        Cell.favoriteButton.tag = indexPath.row
        Cell.forwardTweetButton.tag = indexPath.row
        Cell.tag = indexPath.row
        
        return Cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = TWEETS {
            return tweets.count
        } else {
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("Here..")
        if (segue.identifier == "NewTweetSegue") {
            
            let replyToTweetViewController = segue.destinationViewController as! ReplyToTweetViewController
            let user = User.currentUser!
            let tweetInfo = ReplyTweetUserInfo()
            tweetInfo.userName = user.name
            tweetInfo.userHandle = user.screenName
            tweetInfo.userProfileURL = user.profileImgURL
            replyToTweetViewController.tweetInfo = tweetInfo
        }
    }

}
