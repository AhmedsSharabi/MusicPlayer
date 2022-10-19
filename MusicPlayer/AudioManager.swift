//
//  Audio.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject {
    var player: AVAudioPlayer?
    
    func startPlayer(track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.play()
        } catch {
            print("Failed to initilize player")
        }
    }
    
    
}
