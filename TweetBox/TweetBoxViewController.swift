//
//  ViewController.swift
//  TweetBox
//
//  Created by rcvasant on 2/14/16.
//  Copyright © 2016 rahulkrsna. All rights reserved.
//

import UIKit

class TweetBoxViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TwitterClient(baseURL: twitterBaseURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func proceedWithTwitterLogin(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client.loginWithCompletion({ () -> () in
            print("I have logged in :-D")
            self.performSegueWithIdentifier("loginSegue", sender: self)
            }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
                self.showAnAlert("Login Failed", message: "\(error.localizedDescription)")
        }
    }
    
    func showAnAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: "Warning", message: "Input Error", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController,animated: true) {
            
        }
    }
}

