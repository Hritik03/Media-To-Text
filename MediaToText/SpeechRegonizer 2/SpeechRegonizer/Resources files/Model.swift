//
//  Model.swift
//  SpeechRegonizer
//
//  Created by hb on 24/08/22.
//

import Foundation
import UIKit
import Speech
struct Model{
    
    class CellResource {
        var type : String?
        var speechRecognizer: SFSpeechRecognizer?
        init(type:String? , speechRecognizer:SFSpeechRecognizer?) {
            self.type = type
        self.speechRecognizer = speechRecognizer
        }
    }
}

