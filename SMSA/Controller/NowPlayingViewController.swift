//
//  NowPlayingViewController.swift
//  SMSA
//
//  Created by Matthew Androus on 9/17/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class NowPlayingViewController: UIViewController {
    @IBOutlet weak var SkipForwardButton: UIButton!
    @IBOutlet weak var SkipBackButton: UIButton!
    @IBOutlet weak var PlayPauseButton: UIButton!
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var playbackSlider: CustomSlider!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?

    let seekDuration: Float64 = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Now Playing VC loaded")
        // Do any additional setup after loading the view.
        startPlaying()
        
        //let url = URL(string: image.url)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: SermonsModel.sermonsModel.selectedSermon["image"] as! String)!)
            DispatchQueue.main.async {
                self.artImageView.image = UIImage(data: data!)
                let cornerRadius : CGFloat = 10.0
                self.artImageView.layer.cornerRadius = cornerRadius
                self.artImageView.clipsToBounds = true
            }
        }
        
        //Setting title and description
        let text = (SermonsModel.sermonsModel.selectedSermon["title"] as! String).components(separatedBy: "|")
        titleLabel.text = text[0]
        descriptionLabel.text = text[1]
        
        //setting Pause and Play Buttons
//        PlayPauseButton.setImage(UIImage(named: "checkmark_white"), for: .normal)
//        PlayPauseButton.contentVerticalAlignment = .fill
//        PlayPauseButton.contentHorizontalAlignment = .fill
//        PlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        PlayPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
//
//        SkipForwardButton.setImage(UIImage(named: "checkmark_white"), for: .normal)
//        SkipForwardButton.contentVerticalAlignment = .fill
//        SkipForwardButton.contentHorizontalAlignment = .fill
//        SkipForwardButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        SkipForwardButton.setBackgroundImage(#imageLiteral(resourceName: "forward_10"), for: UIControl.State.normal)
//
//        SkipBackButton.setImage(UIImage(named: "checkmark_white"), for: .normal)
//        SkipBackButton.contentVerticalAlignment = .fill
//        SkipBackButton.contentHorizontalAlignment = .fill
//        SkipBackButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        SkipBackButton.setBackgroundImage(#imageLiteral(resourceName: "replay_10"), for: UIControl.State.normal)
        
        
        // Add playback slider
        playbackSlider!.minimumValue = 0
        
        let duration : CMTime = playerItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = true
        
        playbackSlider!.addTarget(self, action: #selector(NowPlayingViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(playbackSlider!)
        
        player!.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
//            if let duration = self.player?.currentItem?.duration {
//                let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
//                let progress = (time/duration)
//                if true {
            var progress = (self.player?.currentItem?.currentTime().seconds)!
            self.playbackSlider?.value = Float(progress)
            self.progressLabel?.text = "hello" //self.SecondsToHoursMinutesSeconds(secondsDouble: progress)
            self.timeLeftLabel?.text = self.SecondsToHoursMinutesSeconds(secondsDouble:(Double(duration.seconds) - progress))
            print(progress)
            //self.updatedPlaybackSlider(progress: progress)
                //}
            //}
        })
        
        //Add Audio timestamps
//        let progressLabelX = UIScreen.main.bounds.size.width*0.15
//        let progressLabelY = UIScreen.main.bounds.size.height*0.65
//        progressLabel = UILabel(frame: CGRect(x:progressLabelX, y:progressLabelY, width:80, height:20))
//        progressLabel?.text = "-"
//        self.view.addSubview(progressLabel!)
//
//        let timeLeftLabelX = UIScreen.main.bounds.size.width*0.85-20
//        let timeLeftLabelY = UIScreen.main.bounds.size.height*0.65
//        timeLeftLabel = UILabel(frame: CGRect(x:timeLeftLabelX, y:timeLeftLabelY, width:80, height:20))
//        timeLeftLabel?.text = "-"
//        self.view.addSubview(timeLeftLabel!)
        
        
        //Add AirPlay picker
        let audioPickerX = UIScreen.main.bounds.size.width*0.5 - 10
        let audioPickerY = UIScreen.main.bounds.size.height*0.86
        let audioPicker = AVRoutePickerView(frame: CGRect(x:audioPickerX, y:audioPickerY, width:20, height:20))
        audioPicker.tintColor = UIColor(cgColor: PlayPauseButton.tintColor.cgColor) //same color as play button
        self.view.addSubview(audioPicker)
        
        //and grabby handle thingy at the top
        
        
    }
    
//    func updatedPlaybackSlider(progress: Float){
//        print("updating slider to  \(progress * 100)")
//        playbackSlider?.value = 1000
//    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            play()
        }
    }
    
    
    
    func startPlaying(){
        let url  = URL.init(string: SermonsModel.sermonsModel.selectedSermon["url"] as! String)
        
        playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player!)
        
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        play()
        
    }
    
    @IBAction func PlayPausePressed(_ sender: Any) {
        if player?.rate == 0.0 {
            play()
        } else {
            pause()
        }
    }
    
    @IBAction func SkipBackPressed(_ sender: Any) {
        let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = playerCurrentTime - seekDuration
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player!.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        play()
        
    }
    
    func play(){
        player?.play()
        PlayPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
    }
    
    func pause(){
        player?.pause()
        PlayPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
    }
    
    @IBAction func SkipForwardPressed(_ sender: Any) {
        guard let duration  = player?.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
        let newTime = playerCurrentTime + seekDuration
        
        if newTime < (CMTimeGetSeconds(duration) - seekDuration) {
            
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player!.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            play()
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func SecondsToHoursMinutesSeconds(secondsDouble: Double) -> String{
        let secondsInt = Int(secondsDouble)
        let (h,m,s) = (String(format: "%02d", secondsInt / 3600), String(format: "%02d", (secondsInt % 3600) / 60), String(format: "%02d", (secondsInt % 3600) % 60))
        var result = "\(m):\(s)"
        if secondsInt > 3600 {
            result = "\(h):\(m):\(s)"
        }
        return result
    }
}
