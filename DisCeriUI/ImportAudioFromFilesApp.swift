//
//  ImportAudioFromFilesApp.swift
//  DisCeri
//
//  Created by Soren Marcelino on 19/03/2023.
//

import Foundation
import UIKit
import MobileCoreServices

class ImportAudio: UIViewController, UIDocumentPickerDelegate {
    // Action function for a button press

    //weak var parentViewController: UIViewController?
    func importAudioFromFilesApp() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    // Delegate method called when the user has selected a file
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("J'AI !!!")
    }
    
    
    
    /*
    
    // Function to open the Files app interface to select a file
    func importAudioFromFilesApp() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true)
    }
    
    // Delegate method called when the user has selected a file
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("J'AI !!!")
        dismiss(animated: true)
    }*/

}
