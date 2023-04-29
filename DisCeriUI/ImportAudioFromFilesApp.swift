//
//  ImportAudioFromFilesApp.swift
//  DisCeri
//
//  Created by Soren Marcelino on 19/03/2023.
//

import Foundation
import UIKit
import MobileCoreServices

class ImportAudioViewController: UIViewController, UIDocumentPickerDelegate {
    
    var clientVLC = ClientVLC()
    
    func importTapped() {
        //Create a picker specifying file type and mode
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3, .jpeg, .png])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .overFullScreen
        
        // Present the document picker from the root view controller
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var audio = ""
        var cover = ""
        if urls[0].absoluteString.contains(".PNG") || urls[0].absoluteString.contains(".jpeg") {
            cover = urls[0].absoluteString
        }
        if urls[1].absoluteString.contains(".PNG") || urls[1].absoluteString.contains(".jpeg") {
            cover = urls[1].absoluteString
        }
        if urls[0].absoluteString.contains(".mp3") {
            audio = urls[0].absoluteString
        }
        if urls[1].absoluteString.contains(".mp3") {
            audio = urls[1].absoluteString
        }
        print("URL de l'audio : \(audio)")
        print("URL de la pochette : \(cover)")
        var statusAudio = clientVLC.uploadAudioFile(url: URL(string: audio)!)
        var statusCover = clientVLC.uploadCoverFile(url: URL(string: cover)!)
        
        print("Status Audio = \(statusAudio)")
        print("Status Cover = \(statusCover)")
        
        if statusCover {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: showAlertUploadStatusSuccess), object: nil)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: showAlertUploadStatusError), object: nil)
            }
        }
        
        dismiss(animated: true)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}
