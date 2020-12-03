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
        print("Hello world")
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let names = ["charleyrivers", "stmarylake"]
            let name = names.randomElement()!
            self.albumArt = NSImage(named: name)
        }
    }
}
