//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    var isPreview = false
    let playerVM: PlayerViewModel
    @State private var playbackTimeline = 0.0
    @State private var isEditing = false
    @State private var title = ""
    @State private var image: UIImage?
    @State private var artist = ""
    @State private var isLiked = false
    @State private var volume: Float = 0.5
    @State private var lyrics: String = "This Track has no lyrics"
    @State private var showLyrics = false
    @State private var isLooping = false
    @State private var track = "1"
    @State private var tracks = ["1", "2", "FAMA", "3", "4"]
    @State private var tracksIndex = 0
    @State private var backgoundColor: UIColor = .clear
    @State private var loopOption: LoopOptions = .normal
    enum LoopOptions {
        case repeatone, repeatall, normal
    }
    
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // MARK: - Background Color
            
            Color(uiColor: backgoundColor.darker(componentDelta: 0.4))
                .animation(.easeOut(duration: 1), value: backgoundColor)
                .ignoresSafeArea()
            
            // MARK: - Image
            
            if let player = audioManager.player {
                VStack {
                    VStack {
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: player.isPlaying ? 300 : 220, height: player.isPlaying ? 300 : 220)
                                .clipShape(RoundedRectangle(cornerRadius: player.isPlaying ? 12 : 28, style: .continuous))
                                .shadow(radius: 14)
                                .animation(.easeOut(duration: 0.2), value: player.isPlaying)
                        }
                    }
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 73 )
                    .padding(.top, 37)
                    
                    // MARK: - Title, Artist and Options
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(Font.custom("SFProDisplay-Bold",size: 21))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Text(artist)
                                .font(Font.custom("SFProDisplay-Regular",size: 20))
                                .foregroundColor(Color(red: 0.949, green: 0.949, blue: 0.949))
                                .opacity(0.7)
                        }
                        
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        Spacer()
                        Button {
                            isLiked.toggle()
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                                .foregroundColor(isLiked ? .purple : .white)
                                .padding(.horizontal, 24)
                                .offset(y: -7)
                        }
                    }
                    
                   
                    // MARK: - Progress slider
                    
                    VStack {
                        Slider(value: $playbackTimeline, in: 1...player.duration) { editing in
                            if !editing {
                                player.currentTime = playbackTimeline
                                isEditing = editing
                            }
                        }
                        .tint(Color(uiColor: backgoundColor))
                        
                        
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        withAnimation {
                            Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                                .font(Font.custom("SFProDisplay-Regular", size: 14))
                        }
                        Spacer()
                        withAnimation {
                            Text(DateComponentsFormatter.positional.string(from: player.duration - player.currentTime) ?? "1:00")
                                .font(Font.custom("SFProDisplay-Regular", size: 14))
                        }
                    }
                    .padding(.horizontal)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(y: -10)
                    
                    .padding(.bottom, 25)
                    
                    // MARK: - Play Pause Skip
                    
                    HStack {

                        Spacer()
                        Button {
                            if tracksIndex == 0 {
                                tracksIndex = tracks.count - 1
                            } else {
                                tracksIndex -= 1
                            }
                            track = tracks[tracksIndex]
                        } label: {
                            
                            Image(systemName: "backward.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                        }
                        Spacer()
                        Button {
                            audioManager.playPause()
                        } label: {
                            Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: player.isPlaying ? 42 : 41 ))
                                .foregroundColor(.white)
                                .animation(.easeOut(duration: 0.1), value: player.isPlaying)
                        }
                        .buttonStyle(.automatic)
                        
                        Spacer()
                        Button {
                            if tracksIndex == tracks.count - 1 {
                                tracksIndex = 0
                            } else {
                                tracksIndex += 1
                                
                            }
                            track = tracks[tracksIndex]
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        Spacer()
                                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    
                    
                    // MARK: - Volume controller
                    
                    HStack(spacing: 18) {
                        Image(systemName:"volume.fill")
                            .foregroundColor(.white)
                            .opacity(0.7)
                        Slider(value: $volume, in: 0...1)
                            .tint(Color(uiColor: backgoundColor))
                        
                        
                        Image(systemName:"volume.3.fill")
                            .foregroundColor(.white)
                            .opacity(0.7)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    
                    // MARK: - Lyrics and Repeat options
                    HStack(spacing: 80) {
                        Button {
                            showLyrics.toggle()
                        } label: {
                            Image(systemName: "quote.bubble.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        
                        switch loopOption {
                        case .normal :
                                Image(systemName: "repeat")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        loopOption = .repeatall
                                    }
                                    .animation(.easeIn(duration: 0.7), value: loopOption)
                            
                            
                        case .repeatall:

                                Image(systemName: "repeat")
                                    .font(.system(size: 22))
                                    .foregroundColor(.purple)
                                    .onTapGesture {
                                        loopOption = .repeatone
                                    }
                                    .animation(.easeIn(duration: 0.7), value: loopOption)
                            
                        case .repeatone:
                            
                                Image(systemName: "repeat.1")
                                    .font(.system(size: 22))
                                    .foregroundColor(.purple)
                                    .onTapGesture {
                                        loopOption = .normal
                                    }
                                    .animation(.easeIn(duration: 0.7), value: loopOption)
                        }
                        
                    }
                    
                    
                }
                .padding(.horizontal)
                
                
                
            }
        }
        .background( Gradient(colors: [ Color(red: 0.518, green: 0.149, blue: 0.173), Color(red: 0.522, green: 0.2, blue: 0.235), Color(red: 0.318, green: 0.118, blue: 0.141)]))
        .ignoresSafeArea()
        .onAppear {
            audioManager.startPlayer(track: track, isPreview: isPreview)
            Task.init {
                title = await audioManager.metaDataTitle(track: track) as! String
                let data = await audioManager.metaDataImage(track: track)
                image = UIImage(data: data!)
                artist = await audioManager.metaDataArtist(track: track) as! String
                lyrics = await (audioManager.metaDataLyrics(track: track) ?? "This Track has no lyrics") as String
                backgoundColor = (image?.averageColor)!
            }
        }
        .onChange(of: track) { newValue in
            audioManager.startPlayer(track: track, isPreview: isPreview)
            Task.init {
                title = await audioManager.metaDataTitle(track: track) as! String
                let data = await audioManager.metaDataImage(track: track)
                image = UIImage(data: data!)
                artist = await audioManager.metaDataArtist(track: track) as! String
                lyrics = await (audioManager.metaDataLyrics(track: track) ?? "This Track has no lyrics") as String
                backgoundColor = (image?.averageColor)!
                
                
            }
        }
        .onChange(of: volume) { newValue in
            audioManager.player?.volume = volume
        }
        .onChange(of: loopOption) { newValue in
            if loopOption == .repeatone {
                audioManager.player?.numberOfLoops = audioManager.player?.numberOfLoops == 0 ? -1 : 0
                isLooping = audioManager.player?.numberOfLoops != 0
            }
        }
        .onReceive(timer) { _ in
            guard let player = audioManager.player, !isEditing else { return }
            playbackTimeline = player.currentTime
            
            
            
        }
        .sheet(isPresented: $showLyrics) {
            
            LyricsView(lyrics: $lyrics, title: $title, artist: $artist, backgroundColor: $backgoundColor)
        }
        .onChange(of: audioManager.player?.currentTime) { newValue in
            guard let player = audioManager.player else { return }
            if (player.currentTime > player.duration - 0.5) && (loopOption != .repeatone) {
               
                if (tracksIndex == tracks.count - 1) && loopOption == .repeatall {
                    tracksIndex = 0
                } else {
                    if tracksIndex != tracks.count - 1 {
                        tracksIndex += 1
                    }
                    
                }
                track = tracks[tracksIndex]
            }
        }
        
    }
    
}

struct PlayerView_Previews: PreviewProvider {
    static let musicVM = PlayerViewModel(music: Music.data)
    static var previews: some View {
        PlayerView(isPreview: true, playerVM: musicVM)
            .environmentObject(AudioManager())
    }
}




