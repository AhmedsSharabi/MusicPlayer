//
//  ViewModel.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 18/10/2022.
//

import Foundation

class PlayerViewModel: ObservableObject {
    private(set) var music: Music
    
    init(music: Music) {
        self.music = music
    }
}

struct Music {
    let id = UUID()
    let title: String
    let description: String
    let duration: TimeInterval
    let track: String
    let imaage: String
    
    static let data = Music(title: "", description: "", duration: 255, track: "", imaage: "")
}


extension DateComponentsFormatter {
    static let abrivatd: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
}

extension DateComponentsFormatter {
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}
