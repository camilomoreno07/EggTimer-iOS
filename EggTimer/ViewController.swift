//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

var player: AVAudioPlayer?

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    
    
    var secondsRemaining = 0
    
    var dividedTime:Float = 0.0

    var progress:Float = 0
    
    var timer = Timer()
    
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]

    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        progress = 0.0
        
        let hardeness = sender.currentTitle!
        titleLabel.text = hardeness
        secondsRemaining  = eggTimes[hardeness]!
        dividedTime = 1.0/Float(secondsRemaining)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        //example functionality
        if secondsRemaining > 0 {
            
            if progress > 0.0 {
                progressBar.progress = dividedTime
                dividedTime += progress
            
            }
            else{
                progress = dividedTime
                progressBar.progress = 0
                
            }
            titleLabel.text = "\(dividedTime)"
            
            print("\(secondsRemaining)")
            print(progressBar.progress)
            
            secondsRemaining -= 1
        }
        else{
            timer.invalidate()
            progressBar.progress = 1.0
            titleLabel.text = "Done!"
            playSound()
            
        }
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
