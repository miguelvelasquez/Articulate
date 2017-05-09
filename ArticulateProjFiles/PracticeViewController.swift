//
//  PracticeViewController.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 4/20/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class PracticeViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()

    @IBOutlet weak var recordButton: CircleButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var buttonText: UILabel!
    @IBOutlet weak var resultText: UIButton!
    var finalText = ""
    
    var timer = Timer()
    var currentTime = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        resultText.isHidden = true
        recordButton.isEnabled = true
    }

    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                self.recordButton.isEnabled = true
            } else {
                self.recordButton.isEnabled = false
            }
        }
    }
    
    private func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                self.finalText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        buttonText.text = "(Go ahead, I'm listening)"
    }
    
    @IBAction func recordWasPressed(_ sender: Any) {
        print("button was pressed")
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
        } else {
            activitySpinner.isHidden = false
            activitySpinner.startAnimating()
            resultText.isHidden = true
            requestSpeechAuth()
            try! startRecording()
            startTimer()
        }
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PracticeViewController.countDown), userInfo: nil, repeats: true)
    }
    
    func endRecording() {
        //launch message about results
        audioEngine.stop()
        self.recognitionRequest?.endAudio()
        currentTime = 60
        time.text = "01:00"
        activitySpinner.isHidden = true
        resultText.isHidden = false
        recordButton.isEnabled = false
    }

    
    func countDown() {
        currentTime = currentTime - 1
        if (currentTime == 0) {
            timer.invalidate()
            endRecording()
        } else if (currentTime >= 10) {
            time.text = "00:" + String(currentTime)
        } else {
            time.text = "00:0" + String(currentTime)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "getResults" {
                if let dest = segue.destination as? ResultsViewController {
                    dest.results = finalText
                    dest.computeResults()
                }
            }
        }
    }
}



