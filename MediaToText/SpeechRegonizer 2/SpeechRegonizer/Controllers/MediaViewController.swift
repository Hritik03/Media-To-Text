//
//  MediaViewController.swift
//  SpeechRegonizer
//
//  Created by Hritik on 24/08/22.
//

import UIKit
import Speech

class MediaViewController: UIViewController {
    var model = Model()
    @IBOutlet weak var transciptTextField: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnTranscribe: UIButton!
    @IBOutlet weak var tblMedia: UITableView!
    var type:String?
    var arrayCell = [Model.CellResource]()
    var arrUrl = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setUpUI()
    }
    
    
    func registerCell() {
        tblMedia.delegate = self
        tblMedia.dataSource = self
        tblMedia.register(UINib.init(nibName: "MediaTblCellTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaTblCellTableViewCell")
        self.arrayCell.append(Model.CellResource.init(type:"", speechRecognizer: nil))
        
    }
    
    // MARK: SetUP UI
    func setUpUI() {
        transciptTextField.layer.borderWidth = 1
        transciptTextField.layer.borderColor = UIColor.gray.cgColor
        transciptTextField.layer.cornerRadius = 10
        self.btnSave.layer.cornerRadius = btnSave.frame.width / 2
        self.btnTranscribe.layer.cornerRadius = btnTranscribe.frame.width / 2
        self.btnSave.isHidden = true
        
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        self.write(text:self.transciptTextField.text, to: "Hritik", folder: "HritikFiles")
    }
    
    @IBAction func processTheMedia(_ sender: Any) {
        self.strtTransciptofMedia()
    }
    
    // MARK: Save the Output
    func write(text: String, to fileNamed: String, folder: String = "SavedFiles") {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".txt")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    
    func strtTransciptofMedia(){
        if arrUrl.count > 0 {
            if (self.type == "video") {
                SpeechProcessing.shared.convertVideoToAudio(url:(self.arrUrl.last!))
            } else {
                SpeechProcessing.shared.reqForText(url:(self.arrUrl.last!), completionHandler: { success, transcriptString in
                    self.btnSave.isHidden = false
                    self.transciptTextField.text = transcriptString
                })
            }
        }
    }
    
}


// MARK: UITableDataSource
extension MediaViewController :UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCell.count
        
    }
    
    fileprivate func configureCell(_ cell: MediaTblCellTableViewCell) {
        cell.mediaViewControllerObj = self
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.type = type
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTblCellTableViewCell") as? MediaTblCellTableViewCell else {return UITableViewCell()}
        
        self.configureCell(cell)
        return  cell
        
    }
    
}
