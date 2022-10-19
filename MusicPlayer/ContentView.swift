//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

struct ContentView: View {
    var playerVM: PlayerViewModel
    var body: some View {
        PlayerView(playerVM: playerVM )
    }
}

struct ContentView_Previews: PreviewProvider {
    static let musicVM = PlayerViewModel(music: Music.data)
    static var previews: some View {
        ContentView(playerVM: musicVM)
            .environmentObject(AudioManager() )
    }
}
