//
//  VideoCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 11/11/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var myBlurView: UIVisualEffectView!
    
    @IBOutlet weak var myBackgroundView: UIView!

    @IBOutlet weak var webView: UIWebView!
    
    var youtubeUrl = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        myBlurView.layer.cornerRadius = 15
        myBlurView.layer.masksToBounds = true
        myBackgroundView.layer.cornerRadius = 15
        myBackgroundView.layer.masksToBounds = true

       
    }
    
    func selectVideo(withUrl ytURL: String)
    {
        self.youtubeUrl = ytURL
        let webString = "<iframe id=\"player\" type=\"text/html\" width=\"\(self.webView.frame.width-15)\" height=\"\(self.webView.frame.height-15)\" src=\"\(youtubeUrl)?wmode=opaque&amp;rel=0&amp;autohide=1&amp;showinfo=0&amp;wmode=transparent\" frameborder=\"0\" scrolling=\"no\"></iframe>"
        self.webView.loadHTMLString(webString, baseURL: nil)
        self.webView.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
