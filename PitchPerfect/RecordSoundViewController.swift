//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Nguyen Quyet Thang on 27/2/24.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnStopRecording: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _updateUI(isRecording: false)
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        _updateUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(_ sender: Any) {
        _updateUI(isRecording: false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "goToPlaybackScreen", sender: audioRecorder.url)
        }else {
            print("Recording was not succesfully")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlaybackScreen" {
            let destination = segue.destination as! PlaySoundsViewController
            let recoredAudioURL = sender as! URL
            destination.recordedAudioURL = recoredAudioURL
        }
    }
    
    private func _updateUI(isRecording: Bool) {
        lblRecording.text = isRecording ? "Recording In Progress" : "Tap to Record"
        _changeBtnState(btnRecord, isEnable: !isRecording)
        _changeBtnState(btnStopRecording, isEnable: isRecording)
    }
    
    private func _changeBtnState(_ targetBtn: UIButton, isEnable: Bool) {
        if isEnable {
            targetBtn.isEnabled = true
            targetBtn.alpha = 1
        } else {
            targetBtn.isEnabled = false
            targetBtn.alpha = 0.5
        }
    }
}
