//
//  MetadataData.swift
//  cmus-swift
//
//  Created by Changyuan Lin on 12/3/20.
//

import SwiftUI
import Combine

final class MetadataData: ObservableObject {
    var filePath: String?
    @Published var albumArt: NSImage?

    init() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateMetadata)
    }

    func updateMetadata(timer: Timer) {
        if let filePath = CmusRemote.filePath(), filePath != self.filePath {
            self.filePath = filePath
            self.albumArt = CmusRemote.albumArt(for: filePath)
        }
    }
}
