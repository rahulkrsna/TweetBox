//
//  TweetsViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/19/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
var TWEETS: [Tweet]?

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 255, blue: 255, alpha: 0) //UIColor.cyanColor()
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            TWEETS = tweets
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
                print("Error: Unable to load the tweets")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoout(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
