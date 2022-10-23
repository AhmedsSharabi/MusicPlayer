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
    @State private var volume: CGFloat = 0
    @State private var lyrics: String = "This Track has no lyrics"
    @State private var showLyrics = false
    @State private var track = "1"
    @State private var tracks = ["1", "2", "FAMA", "3", "4"]
    @State private var tracksIndex = 0
    @State private var backgoundColor: UIColor = .clear
    
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    // MARK:
    var body: some View {
        ZStack {

            Color(uiColor: backgoundColor.darker(componentDelta: 0.4))
                .animation(.easeOut(duration: 1), value: backgoundColor)
                .ignoresSafeArea()
//                LinearGradient(colors: [ Color(red: 0.518, green: 0.149, blue: 0.173), Color(red: 0.522, green: 0.2, blue: 0.235), Color(red: 0.318, green: 0.118, blue: 0.141)], startPoint: .top, endPoint: .bottom)
//                    .ignoresSafeArea()
//
            
            
            
            
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
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .offset(y: -7)
                        }
                    }
                    
                    
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
                    
                    HStack {
                        //                        let color: Color = audioManager.isLooping ? .purple : .white
                        //                        Button {
                        //                            audioManager.toggleLoop()
                        //                        } label: {
                        //                            Image(systemName: "repeat")
                        //                                .font(.system(size: 24))
                        //                                .foregroundColor(color)
                        //                        }
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
                        //                        Button {
                        //                            audioManager.stop()
                        //                        } label: {
                        //                            Image(systemName: "stop.fill")
                        //                                .font(.system(size: 24))
                        //                                .foregroundColor(.white)
                        //                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    
                    HStack(spacing: 18) {
                        Image(systemName:"volume.fill")
                            .foregroundColor(.white)
                            .opacity(0.7)
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 5)
                            Capsule()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: volume, height: 5)
                            
                            Circle()
                                .fill(Color.white.opacity(1))
                                .frame(width: 20, height: 20)
                                .offset(x: volume)
                                .gesture(DragGesture().onChanged(audioManager.changeVolume(value: )))
                        }
                        .frame(width: UIScreen.main.bounds.width - 160)
                        
                        Image(systemName:"volume.3.fill")
                            .foregroundColor(.white)
                            .opacity(0.7)
                        
                    }
                    .padding(.bottom, 20)
                    
                    Button {
                        showLyrics.toggle()
                    } label: {
                        Image(systemName: "quote.bubble.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
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
                print(backgoundColor)
                print(backgoundColor.darker(componentDelta: 0.4))
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
        .onReceive(timer) { _ in
            guard let player = audioManager.player, !isEditing else { return }
            playbackTimeline = player.currentTime
            
           
            
        }
        .sheet(isPresented: $showLyrics) {
            
            LyricsView(lyrics: $lyrics, title: $title, artist: $artist, backgroundColor: $backgoundColor)
        }
        .onChange(of: audioManager.player?.currentTime) { newValue in
            guard let player = audioManager.player, !isEditing else { return }
            if player.currentTime > player.duration - 0.5 {
                print("finised")
                if tracksIndex == tracks.count - 1 {
                    tracksIndex = 0
                } else {
                    tracksIndex += 1
                    
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

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}



extension UIColor {
    // Add value to component ensuring the result is
    // between 0 and 1
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
}
extension UIColor {
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract r,g,b,a components from the
        // current UIColor
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        
        // Create a new UIColor modifying each component
        // by componentDelta, making the new UIColor either
        // lighter or darker.
        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
}
extension UIColor {
    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    func darker(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*componentDelta)
    }
}
