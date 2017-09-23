//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Mauricio Chirino on 9/10/16.
//  Copyright © 2016 Mauricio Chirino. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet var OuterStackView: UIStackView!
    @IBOutlet var innerStackView: [UIStackView]!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }
    
    // MARK: Event override with a block for handling new layout during transition from portrait to landscape and viceversa.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.setStackViewLayout()
        }, completion: nil)
    }

    // MARK: Handling memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        showAlert("Warning", message: "Audio could be too long, please record another one shorter")
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Initial view setup
    fileprivate func initialViewSetup() {
        setupAudio()
        configureUI(.notPlaying)
        for innerViews in OuterStackView.subviews {
            innerStackView.append(innerViews as! UIStackView)
        }
        setStackViewLayout()
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playSound(rate: 0.5)
            case .fast:
                playSound(rate: 1.5)
            case .chipmunk:
                playSound(pitch: 1000)
            case .vader:
                playSound(pitch: -1000)
            case .echo:
                playSound(echo: true)
            default:
                playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    // MARK: Gets current view orientation and set all stackviews layout according to it
    func setStackViewLayout() {
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait{
            OuterStackView.axis = .vertical
            setNestedStackViewsAxis(.horizontal)
        } else {
            OuterStackView.axis = .horizontal
            setNestedStackViewsAxis(.vertical)
        }
    }
    
    // MARK: Change nested axis stackviews within general stackview.  
    func setNestedStackViewsAxis(_ axisStyle: UILayoutConstraintAxis)  {
        for innerViews in OuterStackView.subviews {
            (innerViews as! UIStackView).axis = axisStyle
        }
    }

}
