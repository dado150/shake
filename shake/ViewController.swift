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
    
    @IBOutlet weak var YouTubePlayer: YouTubePlayerView!
    @IBOutlet weak var titleVideo: UILabel!
    
    var arrayVideo = NSDictionary()
    var getInfoVideo = NSDictionary()
    var getResources = NSDictionary()
    var getVideoID = String()
    var titolo = String()
    var FinalTitle = String()
    

    struct MovieBlock {
        var movieID = String()
        var displayTitle = String()
        
    }
    
    var movieList: [MovieBlock] = []



    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    for var index = 0; index < 49 ; index++ {
                        self.arrayVideo = first[index] as! NSDictionary
                        self.getInfoVideo = self.arrayVideo["snippet"] as! NSDictionary
                        self.getResources = self.getInfoVideo["resourceId"] as! NSDictionary
                        self.getVideoID = self.getResources["videoId"] as! String
                        self.titolo = (self.getInfoVideo["title"] as? String)!
                        self.shortenTitle(self.titolo)
                        
                        var movieBox:MovieBlock = MovieBlock(movieID: self.getVideoID, displayTitle: self.FinalTitle)
                        self.movieList.append(movieBox)
                        
                    }
                }

            }
            
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func motionEnded(motion: UIEventSubtype,withEvent event: UIEvent?) {
        
            if motion == .MotionShake{
                
                let number: Int = 49
                let randomNumber = Int(arc4random_uniform(UInt32(number)))
                
                var pickedMovie = movieList[randomNumber]
                
                self.YouTubePlayer.playerVars = [
                    "playsinline": "1",
                    "controls": "1",
                    "showinfo": "0"
                ]
                
                self.YouTubePlayer.loadVideoID(pickedMovie.movieID)
                self.titleVideo.text = pickedMovie.displayTitle
            }
        
    }
    
    func shortenTitle(realTitle:String) ->String{
        
        if realTitle.rangeOfString("Official") != nil {
            
            var delimiter = " Official"
            var newstr = realTitle
            var shortTitle = newstr.componentsSeparatedByString(delimiter)
            FinalTitle = shortTitle[0]
            //                            self.titleVideo.text = FinalTitle
            
        } else{
            FinalTitle = realTitle
            
        }
        return FinalTitle
    }
}

