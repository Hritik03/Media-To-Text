//
//  AudioManager.swift
//  SpeechRegonizer
//
//  Created by Hritik on 20/06/25.
//

import AVFoundation

final class AudioManager {
  static let shared = AudioManager()

  private var player: AVPlayer?

  private var session = AVAudioSession.sharedInstance()

  private init() {}

    
    private func activateSession() {
            do {
                try session.setCategory(
                    .playback,
                    mode: .default,
                    options: []
                )
            } catch _ {}
            
            do {
                try session.setActive(true, options: .notifyOthersOnDeactivation)
            } catch _ {}
            
            do {
                try session.overrideOutputAudioPort(.speaker)
            } catch _ {}
        }
    
    func startAudio(urlsString:String) {
            
            // activate our session before playing audio
            activateSession()
            
            // TODO: change the url to whatever audio you want to play
            let url = URL(string:urlsString)
            let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            if let player = player {
                player.replaceCurrentItem(with: playerItem)
            } else {
                player = AVPlayer(playerItem: playerItem)
            }
            
            if let player = player {
                player.play()
            }
        }
    
}
