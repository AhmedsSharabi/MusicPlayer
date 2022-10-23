//
//  LyricsView.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 22/10/2022.
//

import SwiftUI

struct LyricsView: View {
    @Binding var lyrics: String
    @Binding var title: String
    @Binding var artist: String
    @Binding var backgroundColor: UIColor
    
    
    var body: some View {
        ZStack {
            
            Color(uiColor: backgroundColor.darker(componentDelta: 0.4)).opacity(0.85)
                .background(BackgroundClearView())
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .center) {
                    Text(title)
                        .font(Font.custom("SFProDisplay-Bold",size: 23))
                        .foregroundColor(.white)
                    Text(artist)
                        .font(Font.custom("SFProDisplay-Regular",size: 20))
                        .foregroundColor(Color(red: 0.949, green: 0.949, blue: 0.949))
                        .opacity(0.7)
                }
                
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text(lyrics)
                            .font(Font.custom("SFProDisplay-Medium",size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                    }
                }
                
            }
            .padding()
        }
        
        
    }
}

struct LyricsView_Previews: PreviewProvider {
    @State static var preview = "Test"
    @State static var preview1 = UIColor.clear
    
    static var previews: some View {
        LyricsView(lyrics: $preview, title: $preview, artist: $preview, backgroundColor: $preview1)
    }
}


struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

 
