//
//  ASRSoapRequest.swift
//  DisCeri
//
//  Created by Soren Marcelino on 15/03/2023.
//

import Foundation
import Swifter

class NLPSoapRequest: ObservableObject {
    var clientVLC = ClientVLC()
    var actionData: String = ""
    var songData: String = ""
    var artistData: String = ""
    let ipAddress = BasicFunctions().getWifiIpAdress()
    
    func requestNLP(text: String) -> String {
        print("Début NLP Request")
            /*guard let url = Bundle.main.url(forResource: "MacronASRTestPart", withExtension: "mp3") else {
                print("Error: Failed to find the music file.")
                return
            }*/
            
            // Read the audio file as data
            /*guard let text = try? Data(contentsOf: text) else {
                print("Could not read str")
                return
            }*/
        
            // Encode the audio file as base64
            let str = text
            print("Requete : \(str)")
            
            // Define the SOAP request payload with the base64-encoded audio
            let soapMessage = """
            <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
                <soap:Body>
                    <transcriptionRequest>
                        <text>\(str)</text>
                    </transcriptionRequest>
                </soap:Body>
            </soap:Envelope>
            """
            
            // Set the URL of the server endpoint
            let ipCERI = "10.126.1.179"
            let ipSoren = "192.168.1.154"
            let ipTheo = "192.168.1.12"
            let urlString = "http://\(ipAddress):45877/action"
            
            // Create a URL request with the SOAP message as the body
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
            request.httpBody = soapMessage.data(using: .utf8)
        
            print("DEBUG 1")
            
            let semaphore = DispatchSemaphore(value: 0)
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print("DEBUG 2")
                if let error = error {
                    print("Error: \(error)")
                    semaphore.signal()
                    return
                }
                print("DEBUG 3")
                guard let data = data, let response = response as? HTTPURLResponse else {
                    print("No data or response received")
                    semaphore.signal()
                    return
                }
                
                print("Response status code: \(response.statusCode)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                
                // MARK: Parse response
                let parser = XMLParser(data: data)
                let delegate = XMLDelegate()
                parser.delegate = delegate
                parser.parse()
                
                self.actionData = delegate.action
                self.songData = delegate.song
                self.artistData = delegate.artist
                
                print("Action asked for : \(self.actionData)")
                print("Song asked for : \(self.songData.capitalized)")
                print("Artist asked for : \(self.artistData.capitalized)")
                      
                if self.actionData == "PlayMusic" || self.actionData == "PlaySong" || self.actionData == "PlayArtist" || self.actionData == "PlaySongAndArtist" {
                    self.clientVLC.play(songData: self.songData, artistData: self.artistData)
                } else if self.actionData == "Stop" {
                    self.clientVLC.stop()
                }
                semaphore.signal()

            }
            task.resume()
            semaphore.wait()
            print("Fin NLP Request")
            return actionData
    }

}
