//
//  TweetsViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/19/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
var TWEETS: [Tweet]?

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 255, blue: 255, alpha: 0) //UIColor.cyanColor()
        
        getHomeTimelineTweets(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
    }
    
    func getHomeTimelineTweets(sinceID: Int) {
        //Get the latest tweets on timeline
        if sinceID == 0 {
            TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
                TWEETS = tweets
                self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print("Error: Unable to load the tweets")
            }
        } else { //Infinite scroll
            TwitterClient.sharedInstance.homeTimelineSinceId(sinceID, success: { (tweets: [Tweet]) -> () in
                TWEETS?.appendContentsOf(tweets)
                self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print("Error: Unable to load the tweets")
            })
        }
        isMoreDataLoading = false
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
        Cell.onRetweet.tag = indexPath.row
        Cell.favoriteButton.tag = indexPath.row
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
