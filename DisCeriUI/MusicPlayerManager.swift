//
//  MusicPlayerManager.swift
//  DisCeri
//
//  Created by Soren Marcelino on 26/02/2023.
//


// MARK: Play local audio file 
import Foundation
import AVFoundation

class MusicPlayerManager: NSObject {
    static let shared = MusicPlayerManager()
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "MacronASRTestPart", withExtension: "mp3") else {
            print("Error: Failed to find the music file.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // infinite
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            isPlaying = true
        } catch let error {
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func toggleMusic() {
        if isPlaying {
            stopMusic()
        } else {
            playMusic()
        }
    }
}

extension MusicPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopMusic()
        }
    }
}
