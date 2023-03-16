//
//  NaturalLanguageProcesser.swift
//  DisCeri
//
//  Created by Soren Marcelino on 02/03/2023.
//

import Foundation
import NaturalLanguage
import CoreML

class Tokenisation {
    
    func tokentizer(transcription: String){
        let string = transcription
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
        tagger.string = string

        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        let range = string.startIndex..<string.endIndex

        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, tag == .personalName || tag == .placeName {
                let musicTitle = String(string[tokenRange])
                print("Music title detected: \(musicTitle)")
            }
            return true
        }
        /*// Initialize the tokenizer with unit of "word"
        let tokenizer = NLTokenizer(unit: .word)
        // Set the string to be processed
        tokenizer.string = transcription
        // Loop over all the tokens and print them
        
        print("tokenisation de :", tokenizer.string!)
        tokenizer.enumerateTokens(in: transcription.startIndex..<transcription.endIndex) { tokenRange, _ in
            print(transcription[tokenRange])
            return true
        }*/
    }
}
