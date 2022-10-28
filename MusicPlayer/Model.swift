//
//  Model.swift
//  MusicPlayer
//
//  Created by Ahmed Sharabi on 28/10/2022.
//

import Foundation
import SwiftUI

struct Music: Equatable {
    let id = UUID()
    var trackname: String
    var title: String
    var artist: String
    var image: UIImage
    var lyrics: String
    var isLiked: Bool
    
}

class TrackInformation: ObservableObject {
    @Published var trackInfo = [Music]()
    @Published var currentTrack = Music(trackname: "", title: "", artist: "", image: UIImage(named: "12")!, lyrics: "", isLiked: false)
    
    func addInfo( info: Music) {
        trackInfo.append(info)
    }
}
