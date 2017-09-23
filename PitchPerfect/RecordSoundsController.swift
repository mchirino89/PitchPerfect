//
//  RecordSoundsController.swift
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
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        recording(true)
        
        let recordingName = "recordedVoice.wav"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            do {
                try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            } catch {
                showAlert("Problem recording audio")
            }
        } catch {
            showAlert("Trouble getting Session category")
        }
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
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
    
    fileprivate func recording(_ enable: Bool) {
        recordButton.isEnabled = !enable
        stopRecordButton.isEnabled = enable
        recordingLabel.text = enable ? "Recording in progress" : "Tap to record"
    }
    
    // MARK: Method called as soon as audio finished recording in device
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "audioSegue", sender: audioRecorder.url)
        } else {
            showAlert("Error saving audio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "audioSegue") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
