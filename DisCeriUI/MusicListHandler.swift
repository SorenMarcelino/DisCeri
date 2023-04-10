//
//  MusicListHandler.swift
//  DisCeri
//
//  Created by Théo QUEZEL-PERRON on 09/04/2023.
//
import Foundation
import Ice

class MusicListHandler {
    let ipSoren = "192.168.1.154"
    let ipCERI = "10.126.2.87"
    
    func getMusic() -> [String] {
        do {
            let communicator = try Ice.initialize(CommandLine.arguments)
            defer {
                communicator.destroy()
            }

            let findMusic = try uncheckedCast(prx: communicator.stringToProxy("SimplePrinter:default -h \(ipSoren) -p 10000")!, type: PrinterPrx.self)
            let result = try findMusic.findFile("")
            
            return result
        } catch {
            print("Error: \(error)\n")
            exit(1)
        }
        //return result
    }
}
