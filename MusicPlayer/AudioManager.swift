//
//  Audio.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import AVKit
import Foundation
import SwiftUI

final class AudioManager: ObservableObject {
    var player: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var isLooping = false
    
    init(player: AVAudioPlayer? = nil, isPlaying: Bool = false, isLooping: Bool = false) {
        self.player = player
        self.isPlaying = isPlaying
        self.isLooping = isLooping
    }
    
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
                isPlaying = true
        } catch {
            print("Failed to initilize player")
        }
    }
    
    func metaData(track: String) async -> Music {
        if let url = Bundle.main.url(forResource: track, withExtension: "mp3") {
            do {
                let asset = AVAsset(url: url)
                let metadata = try await asset.load(.metadata)
                let titleData = AVMetadataItem.metadataItems(from: metadata,
                                                                  filteredByIdentifier: .commonIdentifierTitle)
                let artistData = AVMetadataItem.metadataItems(from: metadata,
                                                              filteredByIdentifier: .commonIdentifierArtist)
                let imageData = AVMetadataItem.metadataItems(from: metadata,
                                                              filteredByIdentifier: .commonIdentifierArtwork)
                let lyrics = try await asset.load(.lyrics)
                
                guard let titleItem = titleData.first else { fatalError() }
                let title = try await titleItem.load(.stringValue)
                guard let artistItem = artistData.first else { fatalError() }
                let artist = try await artistItem.load(.stringValue)
                guard let imageItem = imageData.first else { fatalError() }
                let image: UIImage?
                if let uiimage = (try await imageItem.load(.dataValue)) {
                    let tryImage = UIImage(data: uiimage)
                    image = tryImage
                } else {
                    let tryImage = UIImage(named: "12")
                    image = tryImage
                }
                
                let meta = Music(trackname: track, title: title ?? "No Title", artist: artist ?? "No Artist", image: image! , lyrics: lyrics ?? "This trak has no lyrics", isLiked: false)
                return meta
            } catch {
                print(error.localizedDescription)
            }
            
        }
        fatalError()
    }
    func playPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}
