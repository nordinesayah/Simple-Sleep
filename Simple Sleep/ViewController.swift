//
//  ViewController.swift
//  Simple Sleep
//
//  Created by Nordine Sayah on 02/05/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import UIKit
import AVFoundation
import MoPub

class ViewController: UIViewController, UITableViewDelegate, MPAdViewDelegate, MPInterstitialAdControllerDelegate {

    // $$$$$$$$$
    // IBOUTLET
    // $$$$$$$$$
    
    @IBOutlet weak var textSpeed: UILabel!
    
    @IBOutlet weak var sliderBar: UISlider!

    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var background1: UIImageView!
    @IBOutlet weak var background2: UIImageView!
    @IBOutlet weak var background3: UIImageView!
    @IBOutlet weak var imgFanBlade3: UIImageView!
    @IBOutlet weak var imgFanBlade4: UIImageView!
    @IBOutlet weak var imgFanBlade5: UIImageView!
    @IBOutlet weak var imgFanCage3: UIImageView!
    @IBOutlet weak var imgFanCage4: UIImageView!
    @IBOutlet weak var imgFanCage5: UIImageView!
    
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var viewFan3: UIView!
    @IBOutlet weak var viewFan4: UIView!
    @IBOutlet weak var viewFan5: UIView!
    
    @IBOutlet weak var fanButton1: UIButton!
    @IBOutlet weak var fanButton2: UIButton!
    @IBOutlet weak var fanButton3: UIButton!
    @IBOutlet weak var buttonTimer: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    
    // $$$$$$$$$
    // VARIABLE
    // $$$$$$$$$
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    var player3: AVAudioPlayer?
    var fanButtonPlay1 = true
    var fanButtonPlay2 = false
    var fanButtonPlay3 = false
    var appActive = false
    var timer = Timer()
    var time: Int = 0
    var adView: MPAdView?
    var interstitial: MPInterstitialAdController?
    
    // $$$$$$$$$
    // FUNCTION
    // $$$$$$$$$
    
    override func viewDidLoad() {
        print("*** ViewController - viewDidLoad ***")
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBack), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        adView = MPAdView(adUnitId: "ad72ed52d60b4e699a6f50a0ee43bca2", size: MOPUB_BANNER_SIZE)
        adView?.delegate = self
        adView?.frame = CGRect(x: (view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2, y: view.bounds.size.height - MOPUB_BANNER_SIZE.height, width: MOPUB_BANNER_SIZE.width, height: MOPUB_BANNER_SIZE.height)
        view.addSubview(adView!)
        adView?.loadAd()
    }
    
    // MARK: - <MPAdViewDelegate>
    func viewControllerForPresentingModalView() -> UIViewController? {
        return self
    }
    
    override func loadView() {
        print("*** ViewController - loadView ***")
        super.loadView()
        
        loadInterstitial()
        
        // let 3seconds to load interstitial
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.interstitial?.show(from: self)
        })
    }
    
    func loadInterstitial() {
        print("*** ViewController - loadInterstitial ***")
        // Instantiate the interstitial using the class convenience method.
        interstitial = MPInterstitialAdController(forAdUnitId: "bf806f75482b49049a33d1ed775bc857")
        interstitial?.delegate = self
        
        // Fetch the interstitial ad.
        interstitial?.loadAd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
     ### App moved to background ###
     */
    @objc func appBackground() {
        print("*** ViewController - appBackground ***")
        
        //Active Audio in backGround
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)) , options: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        if appActive == false {
            appActive = true
        }
    }
    
    /*
     ### App is active ###
     */
    @objc func appBack() {
        print("*** ViewController - appBack ***")
        
        //Activate the first time after returning on app + reactivate rotation after returning on app
        if appActive == true {
            appActive = false
            // Increase/Decrease level volume with slider
            player1?.volume = sliderBar.value
            player2?.volume = sliderBar.value
            player3?.volume = sliderBar.value
            
            // Option animation
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
            rotationAnimation.repeatCount = .infinity
            rotationAnimation.isCumulative = true
            
            // Active animation if slider != 0 + speed
            if sliderBar.value > 0.01 && sliderBar.value < 0.3 {
                rotationAnimation.duration = 1.5
                imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            } // Increase speed
            if sliderBar.value >= 0.3 && sliderBar.value < 0.6 {
                rotationAnimation.duration = 1
                imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            } //Increase speed
            if sliderBar.value >= 0.6 && sliderBar.value < 1 {
                rotationAnimation.duration = 0.5
                imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            } //Max speed
            if sliderBar.value == 1 {
                rotationAnimation.duration = 0.2
                imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            }
        }
    }
    
    /*
     ### By default activate fanButton1 when we arrive on the page ###
     */
    override func viewWillAppear(_ animated: Bool) {
        print("*** ViewController - viewWillAppear ***")
        
        manageFan1()
        
        viewFan3.isHidden = false
        
        // Desable button Start who is invisible
        buttonStart.isEnabled = false
        
        let fanImage1 = UIImage(named: "fan_type_3_on")
        let fanImage2 = UIImage(named: "fan_type_4_off")
        let fanImage3 = UIImage(named: "fan_type_5_off")
        
        // Add image fans in the 3 button in bottom page
        fanButton1.setBackgroundImage(fanImage1, for: UIControl.State.normal)
        fanButton2.setBackgroundImage(fanImage2, for: UIControl.State.normal)
        fanButton3.setBackgroundImage(fanImage3, for: UIControl.State.normal)
    }
    
    /*
     ### Manage countdown timer ###
     */
    @objc func updateCounter() {
        print("Timer : \(String(format:"%02d:%02d:%02d", (time/3600)%24, (time/60)%60, (time)%60))")
        
        // When end coutdown remove animation/noise
        if time == 0 {
            imgFanBlade3?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade4?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade5?.layer.removeAnimation(forKey: "rotationAnimation")
            player1?.pause()
            player2?.pause()
            player3?.pause()
            sliderBar.value = 0
        }
        
        // Countdown timer until 0 seconde
        if time > 0 {
            time = time - 1
            timeText.text = "\(String(format:"%02d:%02d:%02d", (time/3600)%24, (time/60)%60, (time)%60))"
        } else {
            timer.invalidate()
        }
    }
    
    /*
     ### Manage fan : volume noise and speed rotation ###
     */
    func manageFan1() {
        
        playSound1()
        
        // Increase/Decrease level volume with slider
        player1?.volume = sliderBar.value
        player2?.volume = sliderBar.value
        player3?.volume = sliderBar.value
        
        // Option animation
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isCumulative = true
        
        // Remove animation if slider == 0
        if sliderBar.value == 0 {
            imgFanBlade3?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade4?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade5?.layer.removeAnimation(forKey: "rotationAnimation")
            player1?.pause()
            player2?.pause()
            player3?.pause()
        } // Active animation if slider != 0 + speed
        if sliderBar.value > 0.01 && sliderBar.value < 0.3 {
            rotationAnimation.duration = 1.5
            imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            player1?.prepareToPlay()
            player1?.play()

        } // Increase speed
        if sliderBar.value >= 0.3 && sliderBar.value < 0.6 {
            rotationAnimation.duration = 1
            imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } //Increase speed
        if sliderBar.value >= 0.6 && sliderBar.value < 1 {
            rotationAnimation.duration = 0.5
            imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } //Max speed
        if sliderBar.value == 1 {
            rotationAnimation.duration = 0.2
            imgFanBlade3?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    
    /*
     ### Manage fan : volume noise and speed rotation ###
     */
    func manageFan2() {
        
        playSound2()
        
        // Increase/Decrease level volume with slider
        player1?.volume = sliderBar.value
        player2?.volume = sliderBar.value
        player3?.volume = sliderBar.value
        
        // Option animation
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isCumulative = true
        
        // Remove animation if slider == 0
        if sliderBar.value == 0 {
            imgFanBlade3?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade4?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade5?.layer.removeAnimation(forKey: "rotationAnimation")
            player1?.pause()
            player2?.pause()
            player3?.pause()
        } // Active animation if slider != 0 + speed
        if sliderBar.value > 0.01 {
            rotationAnimation.duration = 1.5
            imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            player2?.prepareToPlay()
            player2?.play()
            
        } // Increase speed
        if sliderBar.value > 0.3 {
            rotationAnimation.duration = 1
            imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } //Increase speed
        if sliderBar.value > 0.6 {
            rotationAnimation.duration = 0.5
            imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } //Max speed
        if sliderBar.value == 1 {
            rotationAnimation.duration = 0.2
            imgFanBlade4?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    
    /*
     ### Manage fan : volume noise and speed rotation ###
     */
    func manageFan3() {
        
        playSound3()
        
        // Increase/Decrease level volume with slider
        player1?.volume = sliderBar.value
        player2?.volume = sliderBar.value
        player3?.volume = sliderBar.value
        
        // Option animation
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isCumulative = true
        
        // Remove animation if slider == 0
        if sliderBar.value == 0 {
            imgFanBlade3?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade4?.layer.removeAnimation(forKey: "rotationAnimation")
            imgFanBlade5?.layer.removeAnimation(forKey: "rotationAnimation")
            player1?.pause()
            player2?.pause()
            player3?.pause()
        } // Active animation if slider != 0 + speed
        if sliderBar.value > 0.01 {
            rotationAnimation.duration = 1.5
            imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
            player3?.prepareToPlay()
            player3?.play()
            
        } // Increase speed
        if sliderBar.value > 0.3 {
            rotationAnimation.duration = 1
            imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } //Increase speed
        if sliderBar.value > 0.6 {
            rotationAnimation.duration = 0.5
            imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        } //Max speed
        if sliderBar.value == 1 {
            rotationAnimation.duration = 0.2
            imgFanBlade5?.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }

    // $$$$$$
    // AUDIO
    // $$$$$$
    
    /*
     ### Function add audio ###
     */
    func playSound1() {
        let url = Bundle.main.url(forResource: "fan_noise_3", withExtension: "wav")!
        
        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            guard let player1 = player1 else { return }
            
            player1.numberOfLoops = -1
            player1.prepareToPlay()
            player1.play()
        } catch let error as NSError {
            print(error.description)
        }
        player2?.pause()
        player3?.pause()
    }
    
    /*
     ### Function add audio ###
     */
    func playSound2() {
        let url = Bundle.main.url(forResource: "fan_noise_4", withExtension: "wav")!
        
        do {
            player2 = try AVAudioPlayer(contentsOf: url)
            guard let player2 = player2 else { return }
            
            player2.numberOfLoops = -1
            player2.prepareToPlay()
            player2.play()
        } catch let error as NSError {
            print(error.description)
        }
        player1?.pause()
        player3?.pause()
    }
    
    /*
     ### Function add audio ###
     */
    func playSound3() {
        let url = Bundle.main.url(forResource: "fan_noise_5", withExtension: "wav")!

        do {
            player3 = try AVAudioPlayer(contentsOf: url)
            guard let player3 = player3 else { return }
            
            player3.numberOfLoops = -1
            player3.prepareToPlay()
            player3.play()
        } catch let error as NSError {
            print(error.description)
        }
        player1?.pause()
        player2?.pause()
    }

    // $$$$$$$$$$
    // @IBAction
    // $$$$$$$$$$
    
    /*
     ### Manage Slider ###
     */
    @IBAction func slide(_ sender: Any) {
        
        //fits function according to the button
        if fanButtonPlay1 == true {
            manageFan1()
            fanButtonPlay2 = false
            fanButtonPlay3 = false
        }
        
        if fanButtonPlay2 == true {
            manageFan2()
            fanButtonPlay1 = false
            fanButtonPlay3 = false
        }
        
        if fanButtonPlay3 == true {
            manageFan3()
            fanButtonPlay1 = false
            fanButtonPlay2 = false
        }
    }
    
    /*
     ### sets off view timer ###
     */
    @IBAction func buttonTimer(_ sender: Any) {
        print("*** ViewController - buttonTimer ***")
        
        // Reset Timer
        timer.invalidate()
        
        // Change white color text datePicker
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        // Display view + hide/Increase/Decrease button
        timerView.isHidden = false
        buttonTimer.isHidden = true
        textSpeed.isHidden = true
        sliderBar.isHidden = true
        timeText.isHidden = true
        
        // Increase/Decrease button
        buttonStart.isEnabled = true
        buttonTimer.isEnabled = false
        fanButton1.isEnabled = false
        fanButton2.isEnabled = false
        fanButton3.isEnabled = false

        // transparency effect
        firstView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        background1.alpha = 0.5
        background2.alpha = 0.5
        background3.alpha = 0.5
        imgFanCage3.alpha = 0.5
        imgFanCage4.alpha = 0.5
        imgFanCage5.alpha = 0.5
    }
    
    /*
     ### Launch Timer ###
     */
    @IBAction func startTimer(_ sender: Any) {
        print("*** ViewController - startTimer ***")
        
        // Active timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        time = Int(datePicker.countDownDuration)
        
        // Hide view
        timerView.isHidden = true
        
        // Hide button + Text
        buttonTimer.isHidden = false
        textSpeed.isHidden = false
        sliderBar.isHidden = false
        timeText.isHidden = false

        // Increase/Decrease button
        buttonStart.isEnabled = false
        buttonTimer.isEnabled = true
        fanButton1.isEnabled = true
        fanButton2.isEnabled = true
        fanButton3.isEnabled = true
        
        // Remove transparency effect
        firstView.backgroundColor = UIColor(white: 1, alpha: 1)
        imgFanBlade3.alpha = 1
        imgFanBlade4.alpha = 1
        imgFanBlade5.alpha = 1
        background1.alpha = 1
        background2.alpha = 1
        background3.alpha = 1
        imgFanCage3.alpha = 1
        imgFanCage4.alpha = 1
        imgFanCage5.alpha = 1
    }

    /*
     ### Manage Button Fan Bottom Page ###
     */
    @IBAction func clickFan1(_ sender: Any) {
        print("*** ViewController - clickFan1 ***")
        
        manageFan1()
        
        fanButtonPlay1 = true
        fanButtonPlay2 = false
        fanButtonPlay3 = false

        // First fan "ON"
        let fanImage1 = UIImage(named: "fan_type_3_on")
        fanButton1.setBackgroundImage(fanImage1, for: UIControl.State.normal)
        fanButton1.frame = CGRect(x: 5, y: 5, width: 80, height: 80)
        
        // Second fan ventilo "OFF"
        let fanImage2 = UIImage(named: "fan_type_4_off")
        fanButton2.setBackgroundImage(fanImage2, for: UIControl.State.normal)
        fanButton2.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        // Trhird fan "OFF"
        let fanImage3 = UIImage(named: "fan_type_5_off")
        fanButton3.setBackgroundImage(fanImage3, for: UIControl.State.normal)
        fanButton3.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        // Display view animation
        viewFan3.isHidden = false
        viewFan4.isHidden = true
        viewFan5.isHidden = true
    }
    
    /*
     ### Manage Button Fan Bottom Page ###
     */
    @IBAction func clickFan2(_ sender: Any) {
        print("*** ViewController - clickFan2 ***")
        
        manageFan2()
        
        fanButtonPlay1 = false
        fanButtonPlay2 = true
        fanButtonPlay3 = false

        // First fan "ON"
        let fanImage1 = UIImage(named: "fan_type_3_off")
        fanButton1.setBackgroundImage(fanImage1, for: UIControl.State.normal)
        fanButton1.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        // Second fan ventilo "OFF"
        let fanImage2 = UIImage(named: "fan_type_4_on")
        fanButton2.setBackgroundImage(fanImage2, for: UIControl.State.normal)
        fanButton2.frame = CGRect(x: 5, y: 5, width: 80, height: 80)
        
        // Trhird fan "OFF"
        let fanImage3 = UIImage(named: "fan_type_5_off")
        fanButton3.setBackgroundImage(fanImage3, for: UIControl.State.normal)
        fanButton3.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        // Display view animation
        viewFan3.isHidden = true
        viewFan4.isHidden = false
        viewFan5.isHidden = true
    }
    
    /*
     ### Manage Button Fan Bottom Page ###
     */
    @IBAction func clickFan3(_ sender: Any) {
        print("*** ViewController - clickFan3 ***")
        
        manageFan3()
        
        fanButtonPlay3 = true
        fanButtonPlay1 = false
        fanButtonPlay2 = false

        // First fan "ON"
        let fanImage1 = UIImage(named: "fan_type_3_off")
        fanButton1.setBackgroundImage(fanImage1, for: UIControl.State.normal)
        fanButton1.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        // Second fan ventilo "OFF"
        let fanImage2 = UIImage(named: "fan_type_4_off")
        fanButton2.setBackgroundImage(fanImage2, for: UIControl.State.normal)
        fanButton2.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        // Trhird fan "OFF"
        let fanImage3 = UIImage(named: "fan_type_5_on")
        fanButton3.setBackgroundImage(fanImage3, for: UIControl.State.normal)
        fanButton3.frame = CGRect(x: 5, y: 5, width: 80, height: 80)
        
        // Display view animation
        viewFan3.isHidden = true
        viewFan4.isHidden = true
        viewFan5.isHidden = false
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
