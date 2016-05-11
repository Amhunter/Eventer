//
//  HashtagsViewController.swift
//  Eventer
//
//  Created by Grisha on 20/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
protocol HashtagsViewControllerDelegate{
    func didChooseHashtag(controller:HashtagsViewController,Hashtag:String,textRange:NSRange)
}

class HashtagsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var delegate:HashtagsViewControllerDelegate! = nil
    var textRange:NSRange! // range we looking at
    var filterString:NSString = NSString()
    var FoundHashtags:NSMutableArray = NSMutableArray()
    var HashtagsCount:NSMutableArray = NSMutableArray()
    
    var tableView:UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        self.tableView.registerClass(HashtagTableViewCell.self, forCellReuseIdentifier: "Hashtag Cell")

    }
    
    
    func Load_Hashtags(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoundHashtags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell:HashtagTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Hashtag Cell", forIndexPath: indexPath) as! HashtagTableViewCell
        let hashtag:String = FoundHashtags[indexPath.row]["content"] as! String
        //var count:String = count
        Cell.hashtagNameLabel.text = "#\(hashtag)"
        Cell.userInteractionEnabled = true
        let recognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chosenHashtag(_:)))
        Cell.addGestureRecognizer(recognizer)
        return Cell
    }
    
    func chosenHashtag(sender:UITapGestureRecognizer) {
        let Cell:HashtagTableViewCell = sender.view as! HashtagTableViewCell
        let hashtag:NSString = Cell.hashtagNameLabel.text!
        delegate.didChooseHashtag(self, Hashtag: hashtag as String, textRange: self.textRange)
    }

}
