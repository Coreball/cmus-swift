//
//  CmusRemote.swift
//  cmus-swift
//
//  Created by Changyuan Lin on 12/5/20.
//

import SwiftUI
import AVFoundation

class CmusRemote {

    static let cmusURL: URL = URL(fileURLWithPath: "/usr/local/bin/cmus-remote") // Might vary on different systems

    static func filePath() -> String? {
        let statusLines = getStatus().components(separatedBy: .newlines)
        guard let fileLine = statusLines.first(where: {$0.hasPrefix("file ")}) else {
            return nil
        }
        return String(fileLine.dropFirst("file ".count))
    }

    static func albumArt(for trackFilePath: String) -> NSImage? {
        let asset = AVAsset(url: URL(fileURLWithPath: trackFilePath))
        let artworkItems = AVMetadataItem.metadataItems(from: asset.commonMetadata, filteredByIdentifier: .commonIdentifierArtwork)
        if let artworkItem = artworkItems.first, let imageData = artworkItem.dataValue {
            return NSImage(data: imageData)
        } else {
            return nil
        }
    }

    static func getStatus() -> String {
        let outputPipe = Pipe()
        let task = Process()
        task.executableURL = cmusURL
        task.arguments = ["--query"]
        task.standardOutput = outputPipe
        do {
            try task.run()
        } catch {
            fatalError("Could not run cmus-remote")
        }
        task.waitUntilExit()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }

}
