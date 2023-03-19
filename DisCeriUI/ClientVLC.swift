//
//  UploadAudioFileVLC.swift
//  DisCeri
//
//  Created by Soren Marcelino on 16/03/2023.
//

import Foundation
import UIKit
import MobileVLCKit
import Ice

class ClientVLC: NSObject, VLCMediaPlayerDelegate {
    let ipSoren = "192.168.1.154"
    let ipCERI = "10.126.2.87"
    
    func helloWorld() -> UInt32 {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let hello = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipSoren) -p 10000")!, type: PrinterPrx.self)
            try hello.printString("Bonjour")
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
        return 0
    }
    
    func uploadAudioFile() {
        print(FileManager.default.currentDirectoryPath)
        guard let path = Bundle.main.path(forResource: "Lomepal", ofType: "mp3") else {
            print("Error: Failed to find the music file.")
            return
        }
        
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipSoren) -p 10000")!, type: PrinterPrx.self)

            if let file = FileHandle(forReadingAtPath: path) {
                let fileSize = (try? FileManager.default.attributesOfItem(atPath: path)[.size] as? Int64) ?? 0
                let (quotient, remainder) = fileSize.quotientAndRemainder(dividingBy: 102400) // 100kB max = 102400 Bytes

                
                let id = try printer.getNewIndex()
                
                for i in 0..<quotient {
                    file.seek(toFileOffset: UInt64(i * 102400))
                    let part = file.readData(ofLength: 102400)
                    try printer.uploadPart(id: id, part: part)
                }
                
                if remainder > 0 {
                    file.seek(toFileOffset: UInt64(quotient * 102400))
                    let part = file.readData(ofLength: Int(remainder))
                    try printer.uploadPart(id: id, part: part)
                }
                
                file.closeFile()
                try printer.uploadFile(id: id, filename: "Lomepal.mp3")
            }
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
    }
    
    /*func setupPlayer() {
        var player = VLCMediaPlayer()
        player.delegate = self
        let media = VLCMedia(url: URL(string: "http://\(ipSoren):5000/music")!)
        // let url = URL(string: "http://\(ipSoren):5000/music")
        // player.media = VLCMedia(url: url!)
        player.media = media
    }*/
    
    // var player: VLCMediaPlayer!
    
    func play() {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipSoren) -p 10000")!, type: PrinterPrx.self)
            try printer.playFile("Lomepal")

            /*let player = VLCMediaPlayer()
            player.delegate = self
            let media = VLCMedia(url: URL(string: "rtsp://\(ipSoren):5000/music")!)
            player.media = media
            
            player.play()*/
            
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }

        //player?.play()
    }
    
    func pause() {
        
    }
    
    func stop() {
        
    }
}
