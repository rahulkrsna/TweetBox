//
//  TweetsViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/19/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
var TWEETS: [Tweet]?

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,TweetCellDelegate {
    
    var user: User?
    var userHandle: String!
    
    @IBOutlet var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var genView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set the navigationBar background colour
        navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 153.0/255.0, blue: 1.0, alpha: 1.0)

        //Set the navigationBar titleView
//        let uiView = UIView(frame: CGRect.zero)
        
//        let view = UIImageView(image: UIImage(named: "twitter-24"))
//        view.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//        view.contentMode = UIViewContentMode.ScaleAspectFit
//        let homeButton = UIButton(frame: CGRect.zero)
        let homeButton = UIButton(type: UIButtonType.Custom) as UIButton
        homeButton.frame = CGRectMake(0, 0, 24, 24)
        homeButton.setImage(UIImage(named: "twitter-24"), forState: UIControlState.Normal)
        homeButton.imageView?.sizeToFit()
//        homeButton.setTitle("Home", forState: UIControlState.Normal)
//        homeButton.titleLabel?.textColor = UIColor.whiteColor()
        homeButton.addTarget(self, action: "goHome:", forControlEvents: UIControlEvents.TouchUpInside)
//        uiView.addSubview(homeButton)
        
        self.navigationItem.titleView = homeButton
        
        //Refresh Control
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        getHomeTimelineTweets(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        getHomeTimelineTweets(0)
    }
    
    func goHome(sender: AnyObject) {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func getHomeTimelineTweets(sinceID: Int) {
        //Get the latest tweets on timeline
        if sinceID == 0 {
            TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
                TWEETS = tweets
                self.tableView.reloadData()
                self.isMoreDataLoading = false // Infinite Scrolling
                self.refreshControl.endRefreshing() // Scroll to refresh
            }) { (error: NSError) -> () in
                print("Error: Load Tweets : \(error.localizedDescription)")
                self.isMoreDataLoading = false // Infinite Scrolling
                self.refreshControl.endRefreshing() // Scroll to refresh
            }
        } else { //Infinite scroll
            TwitterClient.sharedInstance.homeTimelineSinceId(sinceID, success: { (tweets: [Tweet]) -> () in
                TWEETS?.appendContentsOf(tweets)
                self.tableView.reloadData()
                self.isMoreDataLoading = false
            }, failure: { (error: NSError) -> () in
                print("Error: Load Tweets : \(error.localizedDescription)")
                self.isMoreDataLoading = false
            })
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = TWEETS {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        Cell.tweet = TWEETS![indexPath.row]
        Cell.retweetButton.tag = indexPath.row
        Cell.favoriteButton.tag = indexPath.row
        Cell.forwardTweetButton.tag = indexPath.row
        Cell.tag = indexPath.row
        Cell.delegate = self
        
        return Cell
    }
    
    var isMoreDataLoading = false
    func scrollViewDidScroll(scrollView: UIScrollView) {
      
        if(!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - (3 * tableView.bounds.size.height)
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                if let tweets = TWEETS {
                    getHomeTimelineTweets(Int((tweets.last?.tweetId!)!)!)
                } else {
                    getHomeTimelineTweets(0)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "TweetDetailsSegue") {
            let cell =  sender as! UITableViewCell
            let tweetDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetDetailsViewController.tweet = TWEETS![cell.tag]
            tweetDetailsViewController.tweetIndex = cell.tag
        } else if (segue.identifier == "ReplyToTweetSegue") {
            let replyButton = sender as! UIButton
            let replyToTweetViewController = segue.destinationViewController as! ReplyToTweetViewController
            replyToTweetViewController.tweetIndex = replyButton.tag
            
            let tweet = TWEETS![replyButton.tag]
            let tweetInfo = ReplyTweetUserInfo()
            tweetInfo.userName = tweet.user?.name!
            tweetInfo.userHandle = tweet.user?.screenName!
            tweetInfo.userProfileURL = tweet.user?.profileImgURL!
            
            replyToTweetViewController.tweetInfo = tweetInfo
        } else if (segue.identifier == "UserProfileSegue") {
            // In case it is the current update the information.
            if(self.user?.screenName! == userHandle) {
                TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                }, failure: { (error: NSError) -> () in
                    print("User Information not found")
                })
            }
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.user = self.user
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        user = User.currentUser!
        userHandle = user?.screenName!
    }
    
    func tweetCellProfileImageTap(sender: AnyObject?) {
        
        let recog = sender as! UITapGestureRecognizer
        let view = recog.view
        let cell = view!.superview?.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        self.user = TWEETS![indexPath!.row].user
        performSegueWithIdentifier("UserProfileSegue", sender: nil)
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
