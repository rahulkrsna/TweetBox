//
//  UserViewController.swift
//  TweetBox
//
//  Created by Rahul Krishna Vasantham on 2/20/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit
import AFNetworking

class UserViewController: UIViewController {

    @IBOutlet var titleItem: UINavigationItem!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var userDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigationBar background colour
        navigationController?.navigationBar.barTintColor = UIColor(red: 64.0/255.0, green: 153.0/255.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName :UIColor.whiteColor() ]
        
        userImageView.layer.cornerRadius = userImageView.bounds.width/2
        userImageView.layer.masksToBounds = true
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
    
        if let name = user.screenName {
            self.titleItem.title = "@\(name)"
        }
        
        if let name = user.name {
            self.userNameLabel.text = name
        }
        
        self.followersCountLabel.text = "\(user.followersCount)"
        self.followingCountLabel.text = "\(user.followingCount)"
        self.userDescriptionLabel.text = user.tagline!
        
        if let url = user.profileImgURL {
            self.userImageView.setImageWithURL(url)
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
