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
import MediaPlayer

class NowPlayingViewController: UIViewController, AVRoutePickerViewDelegate {
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
    
    var trackTitle: String?
    var trackDescription: String?
    var trackDuration: Double?
    var seekInProgress = false
    
    let seekDuration: Float64 = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Now Playing VC loaded")
        
        // Do any additional setup after loading the view.
        startPlaying()
        
        
        //setting artwork
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: SermonsModel.sermonsModel.selectedSermon["image"] as! String)!)
            DispatchQueue.main.async {
                self.artImageView.image = UIImage(data: data!)
                let cornerRadius : CGFloat = 10.0
                self.artImageView.layer.cornerRadius = cornerRadius
                self.artImageView.clipsToBounds = true
            }
        }
        
        trackDuration = playerItem!.asset.duration.seconds
        
        //Setting title and description
        let text = (SermonsModel.sermonsModel.selectedSermon["title"] as! String).components(separatedBy: "|")
        trackTitle = text[0]
        trackDescription = text[1]
        
        titleLabel.text = trackTitle
        descriptionLabel.text = trackDescription
        
        
        
        //set up playback slider
        playbackSlider!.minimumValue = 0
        
        let duration : CMTime = playerItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        playbackSlider!.maximumValue = Float(seconds)
        playbackSlider!.isContinuous = true
        
        playbackSlider!.addTarget(self, action: #selector(NowPlayingViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        playbackSlider!.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

        self.view.addSubview(playbackSlider!)
        
        player!.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            if(!self.seekInProgress){
                var progress = (self.player?.currentItem?.currentTime().seconds)!
                self.playbackSlider?.value = Float(progress)
                self.progressLabel?.text = self.SecondsToHoursMinutesSeconds(secondsDouble: progress)
                self.timeLeftLabel?.text = self.SecondsToHoursMinutesSeconds(secondsDouble:(Double(duration.seconds) - progress))
                print(progress)
            }
        })
        
        
        //Add AirPlay picker
//        let audioPickerX = UIScreen.main.bounds.size.width*0.5 - 10
//        let audioPickerY = UIScreen.main.bounds.size.height*0.86
//        let audioPicker = AVRoutePickerView(frame: CGRect(x:audioPickerX, y:audioPickerY, width:20, height:20))
//        audioPicker.tintColor = UIColor(cgColor: PlayPauseButton.tintColor.cgColor) //same color as play button
        //self.view.addSubview(audioPicker)
        
        
        //set up media player and lockscreen controls
        setNowPlayingInfo()
        setupRemoteCommandCenter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SermonsModel.sermonsModel.sameSermonSelected == true {
            print("I hear the selected the same sermon")
            let alertController = UIAlertController(title: "Resume playing?", message: "Would you like to resume playing from where you last left off?", preferredStyle: .alert)
                                
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                print("Yes");
                self.player!.seek(to: CMTime(seconds: SermonsModel.sermonsModel.lastProgress ?? 0.0, preferredTimescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                self.play()
            }

            let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
                //do nothing
            }


            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let index = DataManager.shared.SermonsTVC.tableView.indexPathForSelectedRow{
            DataManager.shared.SermonsTVC.tableView.deselectRow(at: index, animated: true)
        }
        SermonsModel.sermonsModel.lastProgress = player?.currentItem?.currentTime().seconds
        player?.isMuted = true
        player?.pause()
        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
        
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("began")
                seekInProgress = true
                
            case .moved:
                print("moved")
                self.progressLabel?.text = self.SecondsToHoursMinutesSeconds(secondsDouble: Double(slider.value))
                self.timeLeftLabel?.text = self.SecondsToHoursMinutesSeconds(secondsDouble:(Double(trackDuration! - Double(slider.value))))
            case .ended:
                print("lended")
                seekInProgress = false
                setNowPlayingInfo()
            default:
                break
            }
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            play()
        }
        
    }
    
    
    
    func startPlaying() {
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
        PlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func pause(){
        player?.pause()
        PlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
    
    func setNowPlayingInfo()
    {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()

        let title = trackTitle
        let album = trackDescription
        let artworkData = Data()
        let image = UIImage(data: artworkData) ?? UIImage()
        let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: {  (_) -> UIImage in
            return image
        })

        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem!.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem!.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    @IBAction func AirPlayButtonPressed(_ sender: Any) {
        
        
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            self.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            self.pause()
            return .success
        }
    }
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: {
        })
    }
}
