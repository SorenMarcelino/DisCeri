//
//  BasicFunctions.swift
//  IpodSwiftUI
//
//  Created by Soren Marcelino on 09/02/2023.
//

import Foundation
import UIKit
import AVFoundation

class BasicFunctions: NSObject {
    
    public func debugTest() -> String {
        return "Ceci est un test de debug"
    }
    
    public func getWifiIpAdress() -> String {
        let ipSoren = "192.168.1.154"
        let ipCERI = "10.126.1.179"
        
        return ipSoren;
    }
    
    var audioPlayer: AVAudioPlayer?
    func playSound(sound: String, type: String){
        if let path = Bundle.main.path(forResource: sound, ofType: type){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch let error{
                print(error)
            }
        }
    }
    
    // MARK: Fonctionne mais pas ouf
    /*var player: AVAudioPlayer?
    func playSound() {
        guard let url = Bundle.main.url(forResource: "SiriActivation", withExtension: "mp3") else { return }

        do {
            //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()
            
            print("IS PLAYING")

        } catch let error {
            print(error.localizedDescription)
        }
    }
}


extension BasicFunctions: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else { return }
        
        let speechRecognizer = SpeechRecognizer() // Speech
        speechRecognizer.recordButtonTapped()
    }*/
}
