//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Mauricio Chirino on 29/9/16.
//  Copyright © 2016 Mauricio Chirino. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecordButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    // Removed viewDidAppear and others empty methods totally useless in this case.
    
    @IBAction func recordAudio(sender: AnyObject) {
        recording(true)
        
        let recordingName = "recordedVoice.wav"
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            do {
                try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.meteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            } catch {
                showAlert("Problem recording audio")
            }
        } catch {
            showAlert("Trouble getting Session category")
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        recording(false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
        } catch {
            showAlert("Error releasing audio resources")
        }
    }
    
    // MARK: Abstraction for common state changes for buttons
    
    private func recording(enable: Bool) {
        self.recordButton.enabled = !enable
        self.stopRecordButton.enabled = enable
        if enable {
            recordingLabel.text = "Recording in progress"
        } else {
            recordingLabel.text = "Tap to record"
        }
    }
    
    // MARK: Method called as soon as audio finished recording in device
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.performSegueWithIdentifier("audioSegue", sender: audioRecorder.url)
        } else {
            showAlert("Error saving audio")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "audioSegue") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}