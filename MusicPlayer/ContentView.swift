//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioManger: AudioManager
    @EnvironmentObject var trackInfo: TrackInformation
    var body: some View {
        PlayerView()
    }
}
