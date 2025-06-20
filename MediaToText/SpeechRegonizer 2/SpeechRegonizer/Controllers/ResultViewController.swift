//
//  ResultViewController.swift
//  SpeechRegonizer
//
//  Created by hb on 22/08/22.
//

import UIKit
import Speech

class ResultViewController: UIViewController {

  
   
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var outPutText: UITextView!
    var aSting:String?
    var url : URL?
    var typr:String?
    var progressvalue:Float = 0.0
    let aImage = UIImage(systemName: "mic.square.fill")
    class func instance () -> ResultViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
    }
    
    
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.outPutText.text = aSting
     //  intial()
        self.progressbar.progress = progressvalue
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savebtn(_ sender: Any) {
        self.write(text:self.outPutText.text, to: "gaurav", folder: "GauravFiles")
    }
    
    func savedata(data:String) {
        let path =  FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0].appendingPathComponent("aMyFiles")
        if let stringdata = data .data(using: .utf8){
            try? stringdata.write(to: path)
        }
    }
    func write(text: String, to fileNamed: String, folder: String = "SavedFiles") {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    
}
