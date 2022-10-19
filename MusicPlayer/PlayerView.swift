//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    let playerVM: PlayerViewModel
    @State private var playbackTimeline = 0.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Color.black
            VStack {
                
                Slider(value: $playbackTimeline, in: 1...60)
                    .tint(.purple) 
                
                HStack {
                    Text("0:00")
                    Spacer()
                    Text(DateComponentsFormatter.abrivatd.string(from: playerVM.music.duration) ?? "1:00")
                }
                  .font(.caption)
                  .foregroundColor(.white)
                
                HStack {
                    PlaybackControlButton(systemName: "repeat") {
                        
                    }
                    Spacer()
                    PlaybackControlButton(systemName: "gobackward.10") {
                        
                    }
                    Spacer()
                    PlaybackControlButton(systemName: "play.circle.fill", fontSize: 44) {
                        
                    }
                    Spacer()
                    PlaybackControlButton(systemName: "goforward.10") {
                        
                    }
                    Spacer()
                    PlaybackControlButton(systemName: "stop.fill") {
                        
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .onAppear {
            audioManager.startPlayer(track: "1")
        }
        .onReceive(timer) { _ in
            guard let player = audioManager.player else { return }
            playbackTimeline = player.currentTime
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static let musicVM = PlayerViewModel(music: Music.data)
    static var previews: some View {
        PlayerView(playerVM: musicVM)
            .environmentObject(AudioManager())
    }
}
