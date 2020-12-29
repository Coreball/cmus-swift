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
    static let metaflacURL: URL = URL(fileURLWithPath: "/usr/local/bin/metaflac")

    static func playPause() {
        run(arguments: "--pause")
    }

    static func next() {
        run(arguments: "--next")
    }

    static func prev() {
        run(arguments: "--prev")
    }

    static func status() -> String {
        return runWithOutput(arguments: "--query")
    }

    static func filePath() -> String? {
        let statusLines = status().components(separatedBy: .newlines)
        guard let fileLine = statusLines.first(where: { $0.hasPrefix("file ") }) else {
            return nil
        }
        return String(fileLine.dropFirst("file ".count))
    }

    static func albumArt(for trackFilePath: String) -> NSImage? {
        let trackFileURL = URL(fileURLWithPath: trackFilePath)

        // Method 1: AVFoundation Metadata (no FLAC)
        let asset = AVAsset(url: trackFileURL)
        let artworkItems = AVMetadataItem.metadataItems(from: asset.commonMetadata, filteredByIdentifier: .commonIdentifierArtwork)
        if let artworkItem = artworkItems.first, let imageData = artworkItem.dataValue {
            return NSImage(data: imageData)
        }

        // Method 2: Search folder for image file
        let trackFolderURL = trackFileURL.deletingLastPathComponent()
        let imageExtensions = ["png", "jpg", "jpeg"]
        do {
            let folderContents = try FileManager.default.contentsOfDirectory(at: trackFolderURL, includingPropertiesForKeys: nil)
            let imageURLs = folderContents.filter { imageExtensions.contains($0.pathExtension) }
            for imageURL in imageURLs { // Try each image file, fall through to third method if none work
                if let image = NSImage(contentsOf: imageURL) {
                    return image
                }
            }
        } catch {
            print(error)
        }

        // Method 3: metaflac
        let outputPipe = Pipe()
        let task = Process()
        task.executableURL = metaflacURL
        task.arguments = ["--export-picture-to=-", trackFilePath]
        task.standardOutput = outputPipe
        do {
            try task.run()
        } catch {
            print(error)
        }
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        if let image = NSImage(data: outputData) {
            return image
        }

        return nil
    }

    static func run(arguments: String...) {
        let task = Process()
        task.executableURL = cmusURL
        task.arguments = arguments
        do {
            try task.run()
        } catch {
            print(error)
            fatalError("Could not run cmus-remote")
        }
    }

    static func runWithOutput(arguments: String...) -> String {
        let outputPipe = Pipe()
        let task = Process()
        task.executableURL = cmusURL
        task.arguments = arguments
        task.standardOutput = outputPipe
        do {
            try task.run()
        } catch {
            print(error)
            fatalError("Could not run cmus-remote")
        }
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }

}
