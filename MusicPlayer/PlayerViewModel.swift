//
//  ViewModel.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import Foundation
import SwiftUI

class PlayerViewModel: ObservableObject {
    private(set) var music: Music
    
    init(music: Music) {
        self.music = music
    }
}

class Music {
    let id = UUID()
    let track: String
    let isLiked: Bool
    
    
    init(track: String, isLiked: Bool) {
        self.track = track
        self.isLiked = isLiked
    }
    static let example = Music(track: "1", isLiked: false)
}




