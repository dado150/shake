//
//  ViewController.swift
//  shake
//
//  Created by DAdo150 on 23/12/15.
//  Copyright © 2015 DAdo150. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Foundation
import CoreData
import YouTubePlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

       
//        
//        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var context:MSManagedObjectContext = appDel.managedObjectContext!
//        
//        var newMovie = NSEntityDescription.insertNewObjectForEntityForName("My Movies", inManagedObjectContext: context) as MSManagedObject
//        
//        newMovie.setValue("Star Wars", forKey: "title")
    
        
        
//        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let player = AVPlayer(URL: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRectMake(10, 100 , 100, 100)
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
        
//        let address = NSURL(string: "https://www.youtube.com/watch?v=SEyDminvr7Q")
        
    }
    
    @IBOutlet weak var YouTubePlayer: YouTubePlayerView!
       
    @IBOutlet weak var video_Player: UIWebView!
    
    
    
    @IBOutlet weak var titleVideo: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func motionEnded(motion: UIEventSubtype,withEvent event: UIEvent?) {
            
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
                            var title = getInfoVideo["title"] as! String
                            
                            self.YouTubePlayer.playerVars = [
                                "playsinline": "1",
                                "controls": "1",
                                "showinfo": "0"
                            ]
                            
                            self.YouTubePlayer.loadVideoID(getVideoID)

                            print(title)
                            var videoFullTitle = title
      
                                if videoFullTitle.rangeOfString("Trailer") != nil {
                                
                                    var delimiter = " Official"
                                    var newstr = videoFullTitle
                                    var shortTitle = newstr.componentsSeparatedByString(delimiter)
                                    var FinalTitle = shortTitle[0]
                                    self.titleVideo.text = FinalTitle
                                    print(FinalTitle)
                        
                                } else{
                                    self.titleVideo.text = title
                                }
                       }
                        
                    }
                    
                })
                
                task.resume()
            }
            
    }
    
    
    

}

