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
    let ipCERI = "10.126.1.179"
    let ipAddress = BasicFunctions().getWifiIpAdress()
    var resultClientVLC: Bool = false
    
    func getResultClientVLC() -> Bool {
        print("get \(resultClientVLC)")
        return resultClientVLC
    }
        
    func helloWorld() -> UInt32 {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let hello = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
            try hello.printString("Bonjour")
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
        return 0
    }
    
    func uploadAudioFile(url: URL) {
        print(FileManager.default.currentDirectoryPath)
        /*guard let path = Bundle.main.path(forResource: "Lomepal", ofType: "mp3") else {
            print("Error: Failed to find the music file.")
            return
        }*/
        
        do {
            url.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: url)
            print("Je vois l'audio")
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)

            if let file = FileHandle(forReadingAtPath: url.path) {
                let fileSize = (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64) ?? 0
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
                let fileNameWithoutExtension = url.deletingPathExtension().lastPathComponent
                try printer.uploadFile(id: id, filename: "\(fileNameWithoutExtension).mp3")
            }
            url.stopAccessingSecurityScopedResource()
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
    }

    func uploadCoverFile(url: URL) {
        print(FileManager.default.currentDirectoryPath)
        /*guard let path = Bundle.main.path(forResource: "Lomepal", ofType: "mp3") else {
            print("Error: Failed to find the music file.")
            return
        }*/
        
        do {
            url.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: url)
            print("Je vois la pochette")
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)

            if let file = FileHandle(forReadingAtPath: url.path) {
                let fileSize = (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64) ?? 0
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
                let fileNameWithoutExtension = url.deletingPathExtension().lastPathComponent
                let pathExtension = url.pathExtension
                try printer.uploadFile(id: id, filename: "\(fileNameWithoutExtension).\(pathExtension)")
            }
            url.stopAccessingSecurityScopedResource()
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
    
    //var player: VLCMediaPlayer!
    func play(songData: String, artistData: String) {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }
            
            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
            resultClientVLC = try printer.playFile(songData)
            
            print("oui \(resultClientVLC)")
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
        
    }
    
    func pause() {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
            try printer.pause()
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
    }
    
    func resume() {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
            try printer.resume()
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
    }
    
    func stop() {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let printer = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipAddress) -p 10000")!, type: PrinterPrx.self)
            try printer.stopFile()
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
    }
}
