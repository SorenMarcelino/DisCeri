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
    @Published var musicAskedFor: String = "" {
        didSet {
            // Cette méthode est appelée chaque fois que la variable est mise à jour
            miseAJourVue(nouvelleVariable: musicAskedFor)
        }
    }
    
    func miseAJourVue(nouvelleVariable: String) {
        // Mettre à jour la vue avec la nouvelle variable ici
        print(musicAskedFor)
        print("La variable a changé : \(nouvelleVariable)")
    }
    
    func requestNLP(text: String) -> String {
        print("Début NLP Request")
        
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
                self.musicAskedFor = self.songData
                print("Artist asked for : \(self.artistData.capitalized)")
                      
                if self.actionData == "PlaySong" {
                    self.clientVLC.playSong(songData: self.songData)
                }
                else if self.actionData == "PlayArtist" {
                    self.clientVLC.playArtist(artistData: self.artistData)
                }
                else if self.actionData == "PlaySongAndArtist" {
                    self.clientVLC.playSongAndArtist(songData: self.songData, artistData: self.artistData)
                }
                else if self.actionData == "Stop" {
                    self.clientVLC.stop()
                }
                else if self.actionData == "Pause" {
                    self.clientVLC.pause()
                }
                else if self.actionData == "Resume" {
                    self.clientVLC.resume()
                }
                semaphore.signal()
                
            }
            task.resume()
            semaphore.wait()
            print("Fin NLP Request")
            return actionData
    }

}
