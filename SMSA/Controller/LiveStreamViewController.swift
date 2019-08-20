//
//  VideoViewController.swift
//  YoutubeEmbedApp
//
//  Created by MAC on 6/1/19.
//  Copyright © 2019 cagdaseksi. All rights reserved.
//

import UIKit
import WebKit

class LiveStreamViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
//    var video: Video = Video()
    
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.youtube.com/embed/live_stream?channel=UC_eGnmI2MqiwOLncMVLKbOg")
        videoWebView.navigationDelegate = self
        videoWebView.load(URLRequest(url: url!))
        self.Activity.startAnimating()
        self.videoWebView.navigationDelegate = self
        self.Activity.hidesWhenStopped = true

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Activity.stopAnimating()
    }
    
    
    // Not working - Don't know what should be pass in as the string
    @IBAction func onOpenYouTube(_ sender: UIButton) {
        playInYoutube(youtubeId: "UC_eGnmI2MqiwOLncMVLKbOg")
    }
    
    func playInYoutube(youtubeId: String) {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
}
