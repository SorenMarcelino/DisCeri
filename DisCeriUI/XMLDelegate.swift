//
//  XMLDelegate.swift
//  ASR
//
//  Created by Soren Marcelino on 15/03/2023.
//

import Foundation

class XMLDelegate: NSObject, XMLParserDelegate {
    
    var currentElement: String?
    var transcription: String = ""
    var isSong: Bool = false
    var isArtist: Bool = false
    var action: String = ""
    var song: String = ""
    var artist: String = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            currentElement = elementName
            transcription = ""
            print(currentElement)
            switch currentElement {
                case "PlayMusic":
                    action = "Play"
                case "PauseMusic":
                    action = "Pause"
                case "ResumeMusic":
                    action = "Resume"
                case "StopMusic":
                    action = "Stop"
                case "PlaySong":
                    action = "PlaySong"
                case "PlayArtist":
                    action = "PlayArtist"
                case "PlaySongAndArtist":
                    action = "PlaySongAndArtist"
            case .none:
                print("none")
            case .some(_):
                print("some")
            }
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //transcription += string
        switch currentElement {
            case "transcription":
                transcription += string
            case "song":
                song = string
            case "artist":
                artist = string
            default:
                break
        }
    }
        
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = nil
        if elementName == "transciption" {
            print("T:\(transcription)")
        }
        if elementName == "song" {
            isSong = true
        }
        if elementName == "artist" {
            isArtist = true
        }
    }
    
}
