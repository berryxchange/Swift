//
//  ViewController.swift
//  Scribe
//
//  Created by Quinton Quaye on 1/23/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet weak var playButton: CircleButton!
    //@IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    @IBOutlet weak var descriptionText: UILabel!
    
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-us"))
    
    var audioPlayer: AVAudioPlayer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //activitySpinner.isHidden = true
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus{
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                let alert = UIAlertController(title: "Scribe", message: "User denied, access to speech recognition." , preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "close", style: .default, handler: nil)
                
                alert.addAction(closeAction)
                
                self.present(alert, animated: true)
                
                print("User denied, access to speech recognition.")
            case .restricted:
                isButtonEnabled = false
                
                let alert = UIAlertController(title: "Scribe", message: "Speech recognition restricted on this device." , preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "close", style: .default, handler: nil)
                
                alert.addAction(closeAction)
                
                self.present(alert, animated: true)
                print("Speech recognition restricted on this device.")
            case .notDetermined:
                let alert = UIAlertController(title: "Scribe", message: "Speech recognition not yet authorized." , preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "close", style: .default, handler: nil)
                
                alert.addAction(closeAction)
                
                self.present(alert, animated: true)
                print("Speech recognition not yet authorized.")
            }
            
            OperationQueue.main.addOperation {
                self.playButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    
    func startRecording(){
        if recognitionTask != nil{
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: .spokenAudio, options: [])
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch {
            let alert = UIAlertController(title: "Scribe", message: "Audio session properties weren't set because of an error." , preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "close", style: .default, handler: nil)
            
            alert.addAction(closeAction)
            
            self.present(alert, animated: true)
            
            print("Audio session properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeech audio buffer recognition request object.")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
                if result != nil{
                    print(result?.bestTranscription.formattedString)
                self.transcriptionTextField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.playButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){(buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
            
        }catch{
            
            print("audio engine couldn't start because of an error.")
        }
        
        transcriptionTextField.text = "say something, im listening!"
        
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            playButton.isEnabled = true
        }else {
            playButton.isEnabled = false
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        //activitySpinner.stopAnimating()
        //activitySpinner.isHidden = true
    }
    
    /*func requestSpeechAuth(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                
                if let path = Bundle.main.url(forResource: "theQ", withExtension: "m4a"){
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        sound.play()
                        self.audioPlayer.delegate = self
                    }catch {
                        print("Error!")
                    }
                    // need recognizer
                    let recognizer = SFSpeechRecognizer()
                    //need request
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    // needs recognitionTask
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        if let error = error{
                            print("There was an error: \(error)")
                        }else{
                            // print out result in best format.
                            // add PList info: privacy - speech Recognition
                         print(result!.bestTranscription.formattedString)
                            
                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
                        }
                    })
                }
            }
        }
    }
 
 */

    
    @IBAction func playButtonPressed(_ sender: Any) {
        // show hidden spinner
        if audioEngine.isRunning{
            //player.stop()
            print("audio is still playing, will try to stop..")
            //activitySpinner.stopAnimating()
            //activitySpinner.isHidden = true
            recognitionRequest?.endAudio()
            playButton.isEnabled = false
            
            self.audioEngine.stop()
            //inputNode.removeTap(onBus: 0)
            self.recognitionRequest = nil
            self.recognitionTask = nil
            self.descriptionText.text = "Record & Transcribe"
        }else{
            
            startRecording()
        //activitySpinner.isHidden = false
        //activitySpinner.startAnimating()
            self.descriptionText.text = "Stop"
            
        //requestSpeechAuth()
        }
        
        
        
    }
}

