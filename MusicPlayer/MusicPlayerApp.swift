//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    @StateObject var audioManger = AudioManager()
    @StateObject var trackInformation = TrackInformation()
       
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(audioManger).environmentObject(trackInformation)
        }
    }
}
