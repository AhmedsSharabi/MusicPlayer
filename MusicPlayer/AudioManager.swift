//
//  Audio.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import Foundation
import AVKit
import SwiftUI

final class AudioManager: ObservableObject {
    var player: AVAudioPlayer?
    
    @Published var isPlaying = false
    
    @Published var isLooping = false
    
    
    func metaDataTitle(track: String) async -> Any {
        do {
            guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
                print("Resource not found")
                return "error"
            }
            let asset = AVAsset(url: url)
            let metadata = try await asset.load(.metadata)
            let titleItems = AVMetadataItem.metadataItems(from: metadata,
                                                          filteredByIdentifier: .commonIdentifierTitle)
            guard let item = titleItems.first else { return "error" }
            let print = try await item.load(.value)
            
            return print!
        } catch {
            return "error"
        }
    }
    
    func metaDataArtist(track: String) async -> Any {
        do {
            guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
                print("Resource not found")
                return "error"
            }
            let asset = AVAsset(url: url)
            let metadata = try await asset.load(.metadata)
            let titleItems = AVMetadataItem.metadataItems(from: metadata,
                                                          filteredByIdentifier: .commonIdentifierArtist)
            guard let item = titleItems.first else { return "error" }
            let print = try await item.load(.value)
            
            return print!
        } catch {
            return "error"
        }
    }
    
    func metaDataLyrics(track: String) async -> String?{
        do {
            guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
                print("Resource not found")
                return "error"
            }
            let asset = AVAsset(url: url)
            let metadata = try await asset.load(.lyrics)
            
            return metadata
        } catch {
            return "error"
        }
    }

    
    func metaDataImage(track: String) async -> Data? {
        do {
            guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
                print("Resource not found")
                fatalError()
            }
            let asset = AVAsset(url: url)
            let metadata = try await asset.load(.metadata)
            let titleItems = AVMetadataItem.metadataItems(from: metadata,
                                                          filteredByIdentifier: .commonIdentifierArtwork)
            guard let item = titleItems.first else { fatalError()}
            let print = try await item.load(.dataValue)
            
            return print
        } catch {
            fatalError()
        }
    }
    
    func changeVolume(value: DragGesture.Value) {
        if value.location.x >= 0 && value.location.x <= UIScreen.main.bounds.width - 10 {
            let pregress = value.location.x / UIScreen.main.bounds.width - 180
            player?.volume = Float(pregress)
//            withAnimation(Animation.linear(duration: 0.1)){ value.location.x }
            
        }
    }
    
    func startPlayer(track: String, isPreview: Bool = false) {
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
    func playPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            print("pause")
            isPlaying = false
        } else {
            player.play()
            print("play")
            isPlaying = true
        }
        
    }
    func stop() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.stop()
            isPlaying = false
        }
    }
    
    func toggleLoop() {
        guard let player = player else { return }
        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
        isLooping = player.numberOfLoops != 0
        
    }

    
}
