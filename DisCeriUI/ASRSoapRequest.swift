//
//  ASRSoapRequest.swift
//  DisCeri
//
//  Created by Soren Marcelino on 15/03/2023.
//

import Foundation
import Swifter

class ASRSoapRequest {
    var nlpSoapRequest = NLPSoapRequest()
    var transcriptionData: String = ""
    
    func requestASR(audioURL: URL) -> String{
        print("Début ASR Request")
        /*guard let url = Bundle.main.url(forResource: "MacronASRTestPart", withExtension: "mp3") else {
            print("Error: Failed to find the music file.")
            return
        }*/
                
        // Read the audio file as data
        guard let audioData = try? Data(contentsOf: audioURL) else {
            print("Could not read audio file")
            return "error : Could not read audio file"
        }
        
        // Encode the audio file as base64
        let base64Audio = audioData.base64EncodedString()
        print("Audio : \(base64Audio)")
        
        // Define the SOAP request payload with the base64-encoded audio
        let soapMessage = """
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
            <soap:Body>
                <transcriptionRequest>
                    <audio>\(base64Audio)</audio>
                </transcriptionRequest>
            </soap:Body>
        </soap:Envelope>
        """
        
        // Set the URL of the server endpoint
        let ipCERI = "10.126.1.179"
        let ipSoren = "192.168.1.154"
        let ipTheo = "192.168.1.12"
        let urlString = "http://\(ipSoren):45876/transcribe"
        
        // Create a URL request with the SOAP message as the body
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.httpBody = soapMessage.data(using: .utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                semaphore.signal()
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or response received")
                semaphore.signal()
                return
            }
            
            print("Response status code: \(response.statusCode)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            
            let parser = XMLParser(data: data)
            let delegate = XMLDelegate()
            parser.delegate = delegate
            parser.parse()
            
            self.transcriptionData = delegate.transcription
            //print(type(of: transcriptionData))
            print("Transcription \(type(of: self.transcriptionData)) : \(self.transcriptionData)")
            //self.actionData = self.nlpSoapRequest.requestNLP(text: transcriptionData)
            
            //self.transcriptionData = self.nlpSoapRequest.requestNLP(text: transcriptionData)
            print("Fin ASR Request Task : transcriptionData = \(self.transcriptionData)")
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        print("Fin de ASR Request")
        return transcriptionData
    }

}
