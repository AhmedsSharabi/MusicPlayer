//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    @StateObject var audioManager = AudioManager()
    static let musicVM = PlayerViewModel(music: Music.data)
    var body: some Scene {
        WindowGroup {
            ContentView(playerVM: MusicPlayerApp.musicVM)
                .environmentObject(audioManager)
        }
    }
}
