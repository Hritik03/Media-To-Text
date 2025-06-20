//
//  MediaTblCellTableViewCell.swift
//  SpeechRegonizer
//
//  Created by hb on 24/08/22.
//

import UIKit
import AVKit
import AVFoundation
import Speech
class MediaTblCellTableViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: MediaTblCellTableViewCell.self)
    static let cellNib = UINib(nibName: String(describing: MediaTblCellTableViewCell.self), bundle: Bundle.main)
    
    var objectUtility = UtilityClass()
    var mediaViewControllerObj : MediaViewController?
    let aImage = UIImage(systemName: "mic")
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnmediaPick: UIButton!
    @IBOutlet weak var lblmediaName: UILabel!
    @IBOutlet weak var mediaPlay: UIButton!
    @IBOutlet weak var mediaImg: UIImageView!
    var type : String?

    @IBOutlet weak var vwimg: UIView!
    var url:URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpintial()
        // Initialization code
    }
    
    func setUpintial(){
        self.mediaPlay.isHidden = true
        self.mediaImg.contentMode = .scaleToFill
        mediaImg.layer.cornerRadius = mediaImg.bounds.height / 2
        vwimg.layer.cornerRadius = vwimg.bounds.height / 2
        self.vwimg.layer.borderColor = UIColor.gray.cgColor
        self.vwimg.layer.borderWidth = 1
        self.vwimg.isHidden = true
        btnmediaPick.layer.cornerRadius = 10
        topView.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setUpintial()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func playMedia(_ sender: Any) {
        self.playvideo(videourl: url!)
    }
    func playvideo(videourl: URL){
        if self.type == "video" {
            let player = AVPlayer(url: videourl)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.mediaViewControllerObj?.present(playerController, animated: true) {
                player.play()
                
            }
        } else {
            AudioManager.shared.startAudio(urlsString: videourl.absoluteString)
        }
    }
    
    
    @IBAction func MediaPickBtn(_ sender: Any) {
        objectUtility.delegate = self
        objectUtility.obj = mediaViewControllerObj
        objectUtility.ImageGet()
    }
    
}
extension MediaTblCellTableViewCell : ImageGet {
    func setImg(image: UIImage?, url: URL?, name: String?, type: String?) {
        self.type = type
        self.url = url
        if let url = url {
            mediaViewControllerObj?.arrUrl.append(url)
        }
        self.lblmediaName.text = name
        self.mediaImg.contentMode = .scaleToFill
        self.mediaImg.image = image == nil ? aImage : image
        self.mediaPlay.isHidden = self.url == nil ? true : false
        self.vwimg.isHidden = false
        aImage?.withTintColor(.gray)
    }
}
