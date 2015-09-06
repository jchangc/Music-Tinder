//
//  DataViewController.swift
//  Music Tinder
//
//  Created by Apple on 9/4/15.
//  Copyright (c) 2015 MUSIC TINDER. All rights reserved.
//

import UIKit
import AVFoundation

class DataViewController: UIViewController, AVAudioPlayerDelegate, MDCSwipeToChooseDelegate{

    @IBOutlet var childView: UIView!
    var swipeView: SwipeView!
    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: AnyObject?
    var currentIndex: Int = 0
    var song_array = [AnyObject]()
    var song_array_names = [AnyObject]()
    var song_chosen = [AnyObject] ()
//    var responseString: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        swipeView = SwipeView.xibView()
        let options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        swipeView.options = options
        swipeView.setupSwipeToChoose()
        swipeView.frame = self.view.frame
        self.view.addSubview(swipeView)
        swipeView.vcStore = self
        
        //
        var request1 = NSMutableURLRequest(URL: NSURL(string: "http://api.soundcloud.com/users/66427359/tracks?client_id=e9c4bd49893bb5f74e050dbec7ec000b")!)
        request1.HTTPMethod = "GET"
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var err: NSError
            var temp_array = [AnyObject]()
            var temp_array_name = [AnyObject]()
            if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSArray {
                for item in json{
                    temp_array.append(item["id"] as! Int)
                    temp_array_name.append(item["title"] as! String)
                    }
                 }
            for item in temp_array{
                self.song_array.append(item)
            }
            
            for item in temp_array_name{
                self.song_array_names.append(item)
            }
            self.swipeView.loadtrack("\(self.song_array[0])")
            
        })

        }
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        if(direction == MDCSwipeDirection.Right){
            song_chosen.append(song_array_names[currentIndex])
        }
        swipeView = nil
        currentIndex++
        
        swipeView = SwipeView.xibView()
        let options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        swipeView.options = options
        swipeView.setupSwipeToChoose()
        swipeView.frame = self.view.frame
        self.view.addSubview(swipeView)
        
        swipeView.loadtrack("\(song_array[currentIndex])")
        println(song_chosen)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let obj: AnyObject = dataObject {
            self.dataLabel!.text = obj.description
        } else {
            self.dataLabel!.text = ""
        }
        
    }
    

}

