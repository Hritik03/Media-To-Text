//
//  SPeechProcessing.swift
//  SpeechRegonizer
//
//  Created by Hritik on 24/08/22.
//

import Foundation
import Speech
import UIKit

class SpeechProcessing {
    static let shared = SpeechProcessing()
    var totalTime:Double?
    var aarayString = [String] ()
    var speechDur : Double! = 0
    var task : SFSpeechRecognitionTask?
    var count : Int = 0
    
    func reqForText(url:URL , completionHandler: @escaping(Bool, String) -> Void) {
        // A request to recognize speech from arbitrary stored Audio
        let req = SFSpeechURLRecognitionRequest(url:url)
        req.requiresOnDeviceRecognition = true
        let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        // req.shouldReportPartialResults = false
        if(speechRecognizer?.isAvailable)! {
            do {        //print(task?.state)
                var avAudioPlayer = AVAudioPlayer()
                avAudioPlayer = try AVAudioPlayer (contentsOf:url)
                
                let duration = avAudioPlayer.duration
                let ms  = Int((duration.truncatingRemainder(dividingBy: 1))*1000)
                let sec = Int(duration.truncatingRemainder(dividingBy: 60))
                speechDur = duration
                let minutes = Int(duration / 60) % 60
                let hours = Int(duration / 3600)
                // Duration
                print((NSString(format: "Dur: %0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,sec,ms)) as String)
            }
            catch {
                print(error)
            }
            print(req.url)
            task =  speechRecognizer?.recognitionTask(with: req) {
                results , error in
                guard error == nil else {
                    print(error)
                    return
                }
                guard let results = results else {
                    return
                }
                
                let betterString = results.bestTranscription.formattedString
                let string = self.aarayString.joined(separator: ".\n")
//                let updater = CADisplayLink(target: self, selector: #selector(self.progress))
//                updater.frameInterval = 1
//                updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
                //self.totalTime = Double(totaltime)
                if  (results.speechRecognitionMetadata ==  nil){
                } else {
                    
                    let totaltime = ((results.speechRecognitionMetadata!.speechStartTimestamp) + Double(results.speechRecognitionMetadata!.speechDuration)).rounded()
                    self.totalTime = Double(totaltime)
                    print(totaltime)
                    if(totaltime >= self.speechDur - 10.00 && totaltime <= self.speechDur + 10.00){
                        print(totaltime >= self.speechDur - 10.00 && totaltime <= self.speechDur + 10.00)
                        self.aarayString.append(betterString)
                        print("All done")
                        self.task = nil
                        self.count = 1
                        print(self.task?.state.rawValue)
                        
                        completionHandler(true, self.aarayString.first ?? "")
                        
                    } else {
                        self.aarayString.append(betterString)
                    }
                    print(self.aarayString)
                  //  completionHandler(true, self.progressBar?.progress ?? 0, self.aarayString.first ?? "")
                }
            }
        }
        else {
            print("recogniser not available")
        }
    }
    
    // MARK: ConvertVideoToAudio
    func convertVideoToAudio(url:URL){
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory: URL = urls.first {
            let finalURL = documentDirectory.appendingPathComponent("Audio1.m4a")
            
            let bundleURL = url
            try? fileManager.removeItem(at: finalURL)
            let asset = AVAsset(url: bundleURL)
            asset.writeAudioTrack(to: finalURL) {
                if let aData = try? Data(contentsOf: finalURL) {
                    print("Audio Size")
                    print(aData)
                    self.reqForText(url:url ,  completionHandler:{
                        success, aString in
                    })
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func progress(_ progressbar: UIProgressView) {
        if (self.totalTime == nil){
            self.totalTime  = 1.0
            self.totalTime! += 1.0
        }
        let normalizedTime = Float(self.totalTime! / (self.speechDur!))
       // print(normalizedTime)
       // self.progressBar?.progress = normalizedTime
        let currentper = Double((normalizedTime) * 100.00)
        //       lblpercent.text! = "\(String(format: "%.2f", currentper))" + " % "
    }
    
}
