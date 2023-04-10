//
//  XMLParserDelegateCustom.swift
//  DisCeri
//
//  Created by Soren Marcelino on 02/04/2023.
//

import Foundation

class XMLParserDelegateCustom: NSObject, XMLParserDelegate {
    var foundTranscriptionData = false
    var transcriptionData: String?
        
        /*func parser(_ parser: XMLParser, foundCharacters string: String) {
            if foundTranscriptionData {
                foundTranscriptionData = false
                print("No transcription in XML")
            }
        }*/
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            if elementName == "transcription" {
                foundTranscriptionData = true
            }
        }
}
