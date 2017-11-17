//
//  headerView.swift
//  Instragram
//
//  Created by Ahmad Idigov on 10.12.15.
//  Copyright © 2015 Akhmed Idigov. All rights reserved.
//

import UIKit
import Parse


class headerView: UICollectionReusableView {
    
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        
        posts.frame = CGRect(x: width / 2.5, y: avaImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width / 1.7, y: avaImg.frame.origin.y, width: 50, height: 30)
        followings.frame = CGRect(x: width / 1.25, y: avaImg.frame.origin.y, width: 50, height: 30)
        
        postTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followersTitle.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
        followingsTitle.center = CGPoint(x: followings.center.x, y: followings.center.y + 20)
        
        button.frame = CGRect(x: postTitle.frame.origin.x, y: postTitle.center.y + 20, width: width - postTitle.frame.origin.x - 10, height: 30)
        button.layer.cornerRadius = button.frame.size.width / 50
        
        fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x, y: avaImg.frame.origin.y + avaImg.frame.size.height, width: width - 30, height: 30)
        webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5, y: fullnameLbl.frame.origin.y + 15, width: width - 30, height: 30)
        bioLbl.frame = CGRect(x: avaImg.frame.origin.x, y: webTxt.frame.origin.y + 30, width: width - 30, height: 30)
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
    
    @IBAction func block(sender: AnyObject) {
//        let blockQuery = PFQuery(className: "blocked")
//        blockQuery.whereKey("by", equalTo: "currentUsername")
//        blockQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
//            var blockedUsernames: Set<String> = []
//            if let objects = objects {
//                for object in objects {
//                    blockedUsernames.append(object.valueForKey("blocked") as! String)
//                }
//            }
//            
//            /// Now we get all the names of the users the current user is following
//            let followingQuery = PFQuery(className: "follow")
//            followingQuery.whereKey("follower", equalTo: "currentUsername")
//            followingQuery.orderByAscending("createdAt")
//            followingQuery.findObjectsInBackgroundWithBlock { (objects: [PFObjects]?, error: NSError?) in
//                var usernamesFollowing: Set<String> = []
//                if let objects = objects {
//                    for object in objects {
//                        usernamesFollowing.append(object.valueForKey("following") as! String)
//                    }
//                }
//                
//                /// Finally we subtract all the blockedUsernames from usernames we are following, remember to add the currentUsername into this
//                let usernamesToLoad = usernamesFollowing.subtract(blockedUsernames)
//                
//            }
//        }

    }
    
    // clicked follow button from GuestVC
    @IBAction func followBtn_clicked(_ sender: AnyObject) {
        
        let title = button.title(for: UIControlState())
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = guestname.last!
            object.saveInBackground(block: { (success, error) -> Void in
                if success {
                    self.button.setTitle("FOLLOWING", for: UIControlState())
                    self.button.backgroundColor = .green
                    
                    // send follow notification
                    let newsObj = PFObject(className: "news")
                    newsObj["by"] = PFUser.current()?.username
                    newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                    newsObj["to"] = guestname.last
                    newsObj["owner"] = ""
                    newsObj["uuid"] = ""
                    newsObj["type"] = "follow"
                    newsObj["checked"] = "no"
                    newsObj.saveEventually()
                    
                    
                } else {
                    print(error?.localizedDescription ?? String())
                }
            })
            
            // unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackground(block: { (objects, error) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success, error) -> Void in
                            if success {
                                self.button.setTitle("FOLLOW", for: UIControlState())
                                self.button.backgroundColor = .lightGray
                                
                                
                                // delete follow notification
                                let newsQuery = PFQuery(className: "news")
                                newsQuery.whereKey("by", equalTo: PFUser.current()!.username!)
                                newsQuery.whereKey("to", equalTo: guestname.last!)
                                newsQuery.whereKey("type", equalTo: "follow")
                                newsQuery.findObjectsInBackground(block: { (objects, error) -> Void in
                                    if error == nil {
                                        for object in objects! {
                                            object.deleteEventually()
                                        }
                                    }
                                })
                                
                                
                            } else {
                                print(error?.localizedDescription ?? String())
                            }
                        })
                    }
                    
                } else {
                    print(error?.localizedDescription ?? String())
                }
            })
            
        }
        
    }
   
}
