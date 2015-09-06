//
//  SwipeView.swift
//  Music Tinder
//
//  Created by Apple on 9/5/15.
//  Copyright (c) 2015 MUSIC TINDER. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SwipeView: MDCSwipeToChooseView {
    class func xibView() -> SwipeView {
        return NSBundle.mainBundle().loadNibNamed("DataView", owner: self, options: nil).first! as! SwipeView
    }
    
    var vcStore: UIViewController?
    
    @IBAction func SongPage(sender: UIButton!) {
        vcStore!.performSegueWithIdentifier("toSongList", sender: sender)
        
    }

    @IBOutlet var songInfoBox: UITextView!
    @IBOutlet var AlbumArtView: UIImageView!
    @IBOutlet var PlayButton: UIButton!
    var streamUrl: NSURL?
    var player: AVPlayer!
    var buttonState: Bool = false
    
    @IBAction func PlayButton(sender: UIButton!) {
        if buttonState {
            self.player.pause()
            PlayButton.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
            buttonState = !buttonState
        }
        else {
            self.player.play()
            PlayButton.setImage(UIImage(named: "stop.png"), forState: UIControlState.Normal)
            buttonState = !buttonState
            
        }
        
    }
    
    func loadtrack (track_ID: String){
        
        func httpGet(request: NSURLRequest!, callback: (NSData, String?) -> Void) {
            var session = NSURLSession.sharedSession()
            var task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                if error != nil {
                    callback(NSData(), error.localizedDescription)
                } else {
                    callback(data, nil)
                }
            }
            task.resume()
        }
        var request = NSMutableURLRequest(URL: NSURL(string: "http://api.soundcloud.com/tracks/" + track_ID + "?client_id=e9c4bd49893bb5f74e050dbec7ec000b")!)
        httpGet(request){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
            }
            
            var parseError: NSError?
            let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            //the collection of info from the track
            let track_info = parsedObject as! [String: AnyObject]
            
            //getting the link for streaming
            var stream_link = track_info["stream_url"] as! String
            stream_link += "?client_id=e9c4bd49893bb5f74e050dbec7ec000b"
            
            //getting the link for the artwork
            var artwork_link = track_info["artwork_url"] as! String
            
            //getting the artist name
            var song_info = track_info["title"] as! String
            
            
            let imageURL = NSURL(string: artwork_link)!
            NSURLSession.sharedSession().dataTaskWithURL(imageURL, completionHandler: { (data, response, error) -> Void in
                if let imageData = data {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.AlbumArtView.image = UIImage (data: imageData)
                        
                    })
                }
            }).resume()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.songInfoBox.text = song_info
                
            })
            
            self.streamUrl = NSURL(string: stream_link)
            println(self.streamUrl)
            self.player = AVPlayer(URL: self.streamUrl)
            self.player.play()
        }
        
    }
    
}



