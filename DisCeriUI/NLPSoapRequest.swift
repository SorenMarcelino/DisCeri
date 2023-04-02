//
//  ASRSoapRequest.swift
//  DisCeri
//
//  Created by Soren Marcelino on 15/03/2023.
//

import Foundation
import Swifter

class NLPSoapRequest {
    func requestNLP(text: String) {
        /*guard let url = Bundle.main.url(forResource: "MacronASRTestPart", withExtension: "mp3") else {
            print("Error: Failed to find the music file.")
            return
        }*/
        
        // Read the audio file as data
        guard let text = try? Data(contentsOf: text) else {
            print("Could not read str")
            return
        }
        
        // Encode the audio file as base64
        let str = text
        
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
        let ipCERI = "10.126.2.87"
        let ipSoren = "192.168.1.154"
        let ipTheo = "192.168.1.12"
        let urlString = "http://\(ipTheo):45877/"
        
        // Create a URL request with the SOAP message as the body
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.httpBody = soapMessage.data(using: .utf8)
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or response received")
                return
            }
            
            print("Response status code: \(response.statusCode)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
        }
        task.resume()
    }

}
