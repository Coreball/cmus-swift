//
//  MetadataData.swift
//  cmus-swift
//
//  Created by Changyuan Lin on 12/3/20.
//

import SwiftUI
import Combine

final class MetadataData: ObservableObject {
    @Published var albumArt: NSImage?

    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let filePath = CmusRemote.filePath() {
                self.albumArt = CmusRemote.albumArt(for: filePath)
            } else {
                print("No file")
            }
        }
    }
}
