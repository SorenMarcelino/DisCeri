//
//  SpeechRecognitionTest.swift
//  DisCeri
//
//  Created by Soren Marcelino on 26/02/2023.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognitionManager {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "fr-FR"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    var recognizedText = ""
    
    func startRecognition(){
        // Cancel the previous task if it's running.
        recognitionTask?.cancel() //MARK: Added
        self.recognitionTask = nil //MARK: Added
        
        // Configure the audio session for the app.
        do{
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            print(error)
        }
        
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if authStatus == .authorized {
                self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                let inputNode = self.audioEngine.inputNode
                
                guard let recognitionRequest = self.recognitionRequest else {
                    return
                }
                
                recognitionRequest.shouldReportPartialResults = true
                
                self.recognitionTask = self.recognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                    if let result = result {
                        let recognizedString = result.bestTranscription.formattedString
                        self.recognizedText = recognizedString
                        print("Not final Text : \(result.bestTranscription.formattedString)") // Print the results during listening
                    }
                })
                
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                    recognitionRequest.append(buffer)
                }
                
                self.audioEngine.prepare()
                
                do {
                    try self.audioEngine.start()
                } catch {
                    print("Error starting audio engine: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func stopRecognition() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.cancel()
    }
}
