//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var trackInfo: TrackInformation
    @EnvironmentObject var audioManager: AudioManager
    @State var shouldUpdateList = true
    @State var showingPlayer = false
    var tracks = [ "1", "2", "3", "4", "5", "6"]
    @State var tappedColor: Color = .black
    @State var showPlayer = false
    @State var playbackTimeline = 0.0
    @State var isEditing = false
    @State var volume: Float = 0.5
    @State var loopOption: LoopOptions = .normal
    @State var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var backgoundColor: UIColor = .clear
    @State var showLyrics = false
    @State var tracksIndex = 0
    @Namespace var animation
    @Namespace var animation2
    
    
    enum LoopOptions {
        case repeatone, repeatall, normal
    }
    var body: some View {
        if !showingPlayer {
            NavigationStack {
                ZStack {
                    
                    VStack {
                        List {
                            ForEach(trackInfo.trackInfo, id: \.id) { item in
                                HStack {
                                    Image(uiImage: item.image)
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(14)
                                    VStack (alignment: .leading){
                                        Text(item.title)
                                            .foregroundColor(self.trackInfo.currentTrack == item ? .red : .primary)
                                            .font(Font.custom("SFProDisplay-Medium", size: 14))
                                            .animation(.easeInOut(duration: 0.1), value: trackInfo.currentTrack)
                                        Text(item.artist)
                                            .foregroundColor(self.trackInfo.currentTrack == item ? .red : .secondary)
                                            .font(Font.custom("SFProDisplay-Regular", size: 13))
                                    }
                                }
                                .onTapGesture {
                                    audioManager.startPlayer(track: item.trackname)
                                    trackInfo.currentTrack = item
                                }
                                
                            }
                            
                        }
                        .listStyle(.plain)
                        HStack {
                            HStack {
                                Image(uiImage: trackInfo.currentTrack.image)
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .cornerRadius(14)
                                    .matchedGeometryEffect(id: "Image", in: animation)
                                VStack(alignment: .leading) {
                                    Text(trackInfo.currentTrack.title)
                                        .font(Font.custom("SFProDisplay-Medium", size: 14))
                                        .matchedGeometryEffect(id: "Title", in: animation)
                                    Text(trackInfo.currentTrack.artist)
                                        .font(Font.custom("SFProDisplay-Regular", size: 13))
                                        .matchedGeometryEffect(id: "Artist", in: animation)
                                }
                            }
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showingPlayer.toggle()
                                }
                            }
                            Spacer()
                            if let player = audioManager.player {
                                Button {
                                    audioManager.playPause()
                                } label: {
                                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.primary)
                                        .animation(.easeOut(duration: 0.1), value: player.isPlaying)
                                }
                                .padding(.horizontal)
                                .buttonStyle(.automatic)
                            }
                        }
                        .frame(width: 390, height: 60)
                        .background(Color(uiColor: (trackInfo.currentTrack.image.averageColor?.darker(componentDelta: 0.3))!))
                        .cornerRadius(12)
                        .padding()
                    }
                }
                .onAppear {
                    Task.init {
                        if trackInfo.trackInfo.isEmpty {
                            for track in tracks {
                                let data = await audioManager.metaData(track: track)
                                trackInfo.addInfo(info: data)
                            }
                        }
                    }
                    
                }
                .navigationTitle("Library")
            }
        }
        if showingPlayer {
            NavigationStack {
                ZStack {
                    // MARK: - Background Color
                    
                    Color(uiColor: backgoundColor.darker(componentDelta: 0.3))
                        .animation(.easeOut(duration: 1), value: backgoundColor)
                        .ignoresSafeArea()
                    
                    // MARK: - Image
                    
                    if let player = audioManager.player {
                        VStack {
                            if !showLyrics {
                                VStack {
                                    if let image = trackInfo.currentTrack.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: player.isPlaying ? 300 : 220, height: player.isPlaying ? 300 : 220)
                                            .clipShape(RoundedRectangle(cornerRadius: player.isPlaying ? 12 : 28, style: .continuous))
                                            .shadow(radius: 14)
                                            .animation(.easeOut(duration: 0.2), value: player.isPlaying)
                                            .matchedGeometryEffect(id: "Image", in: animation, anchor: .bottom)
                                            .onTapGesture {
                                                withAnimation {
                                                showLyrics.toggle()
                                            }
                                            }
                                    }
                                }
                                .frame(width: 300, height: 270)
                                .padding(.bottom, 73 )
                                .padding(.top, 37)
                                
                                // MARK: - Title, Artist and Options
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(trackInfo.currentTrack.title)
                                            .font(Font.custom("SFProDisplay-Bold",size: 21))
                                            .foregroundColor(.white)
                                            .matchedGeometryEffect(id: "Title", in: animation)
                                            .matchedGeometryEffect(id: "Title", in: animation2)
                                            .lineLimit(1)
                                        Text(trackInfo.currentTrack.artist)
                                            .font(Font.custom("SFProDisplay-Regular",size: 20))
                                            .matchedGeometryEffect(id: "Artist", in: animation)
                                            .matchedGeometryEffect(id: "Artist", in: animation2)
                                        
                                            .foregroundColor(Color(red: 0.949, green: 0.949, blue: 0.949))
                                            .opacity(0.7)
                                    }
                                    
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                    Spacer()
                                    Button {
                                        trackInfo.currentTrack.isLiked.toggle()
                                        trackInfo.trackInfo[tracksIndex] = trackInfo.currentTrack
                                    } label: {
                                        Image(systemName: "heart.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor( trackInfo.currentTrack.isLiked ? .purple : .white)
                                            .padding(.horizontal, 24)
                                            .offset(y: -7)
                                    }
                                }
                            }
                            
                            if showLyrics {
                                
                                VStack {
                                    VStack(alignment: .center) {
                                        Text(trackInfo.currentTrack.title)
                                            .matchedGeometryEffect(id: "Title", in: animation2)
                                            .font(Font.custom("SFProDisplay-Bold",size: 23))
                                            .foregroundColor(.white)
                                        Text(trackInfo.currentTrack.artist)
                                            .matchedGeometryEffect(id: "Artist", in: animation2)
                                            .font(Font.custom("SFProDisplay-Regular",size: 20))
                                            .foregroundColor(Color(red: 0.949, green: 0.949, blue: 0.949))
                                            .opacity(0.7)
                                    }
                                    
                                    
                                    ScrollView(showsIndicators: false) {
                                        VStack {
                                            Text(trackInfo.currentTrack.lyrics)
                                                .font(Font.custom("SFProDisplay-Medium",size: 16))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                            
                                        }
                                    }
                                    
                                }
                                .frame(width: 300, height: 412)
                                .padding()
                            }
                            
                            // MARK: - Progress slider
                            
                            VStack {
                                Slider(value: $playbackTimeline, in: 1...player.duration) { editing in
                                    if !editing {
                                        audioManager.player?.currentTime = playbackTimeline
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
                                    tracksIndex = trackInfo.trackInfo.firstIndex {$0 == trackInfo.currentTrack} ?? 1
                                    if tracksIndex == 0 {
                                        tracksIndex = tracks.count - 1
                                    } else {
                                        tracksIndex -= 1
                                    }
                                    trackInfo.currentTrack = trackInfo.trackInfo[tracksIndex]
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
                                    if tracksIndex == trackInfo.trackInfo.count - 1 {
                                        tracksIndex = 0
                                    } else {
                                        tracksIndex += 1
                                        
                                    }
                                    trackInfo.currentTrack = trackInfo.trackInfo[tracksIndex]
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
                                    withAnimation {
                                        showLyrics.toggle()
                                    }
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
                .onChange(of: volume) { newValue in
                  audioManager.player?.volume = volume
                }
                .onChange(of: loopOption) { newValue in
                    if loopOption == .repeatone {
                        audioManager.player?.numberOfLoops = audioManager.player?.numberOfLoops == 0 ? -1 : 0
                        audioManager.isLooping = audioManager.player?.numberOfLoops != 0
                    }
                }
                .onReceive(timer) { _ in
                    if let player = audioManager.player {
                        playbackTimeline = player.currentTime
                    }
                }
                .onChange(of: audioManager.player?.currentTime) { newValue in
                    guard let player = audioManager.player else { return }
                    if (player.currentTime > player.duration - 0.5) && (loopOption != .repeatone) {
                       
                        if (tracksIndex == trackInfo.trackInfo.count - 1) && loopOption == .repeatall {
                            tracksIndex = 0
                        } else {
                            if tracksIndex != trackInfo.trackInfo.count - 1 {
                                tracksIndex += 1
                            }
                            
                        }
                        trackInfo.currentTrack = trackInfo.trackInfo[tracksIndex]
                    }
                }
                .onChange(of: trackInfo.currentTrack.id) { _ in
                    backgoundColor = trackInfo.currentTrack.image.averageColor ?? .black
                    audioManager.startPlayer(track: trackInfo.currentTrack.trackname)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button {
                            withAnimation {
                                showingPlayer.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                        }
                    }
                }
                .onAppear {
                    backgoundColor = trackInfo.currentTrack.image.averageColor ?? .black
                }
                
            }
        }
        
    }
}
