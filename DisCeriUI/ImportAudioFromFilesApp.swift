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
    
    func importTapped() {
        //Create a picker specifying file type and mode
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .overFullScreen
        
        // Present the document picker from the root view controller
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        dismiss(animated: true)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

