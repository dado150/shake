//
//  ViewController.swift
//  shake
//
//  Created by DAdo150 on 23/12/15.
//  Copyright © 2015 DAdo150. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if motion == .MotionShake{
                
                let number: Int = 50
                let randomNumber = Int(arc4random_uniform(UInt32(number)))
                print(randomNumber)
                
                
                let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=UUi8e0iOVk1fEOogdfu4YgfA&key=AIzaSyAJjIyppyws7NCRVBwKYWBjw1mAkpD05wQ")
                
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        
                        print(error)
                        
                    } else {
                        
                        var err: NSError?
                        
                        var jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                        
                        if err != nil {
                            
                            print(err)
                            
                        } else {
                            
                            var first = jsonResult["items"] as! NSArray
                            var arrayVideo = first[randomNumber] as! NSDictionary
                            var getInfoVideo = arrayVideo["snippet"] as! NSDictionary
                            var getResources = getInfoVideo["resourceId"] as! NSDictionary
                            var getVideoID = getResources["videoId"] as! String
                            print(getVideoID)
                            
                        }
                        
                    }
                    
                })
                
                task.resume()
            }
            
    }
    
    

}

