//
//  RecordAudio.swift
//  DisCeri
//
//  Created by Soren Marcelino on 16/03/2023.
//

import AVFoundation

class AudioRecorder {
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true)

            audioURL = getDocumentsDirectory().appendingPathComponent("recording.wav")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.record()
        } catch let error {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        guard let audioURL = audioURL else {
            return
        }
        ASRSoapRequest().requestASR(audioURL: audioURL)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
}
