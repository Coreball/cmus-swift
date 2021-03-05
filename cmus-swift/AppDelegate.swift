//
//  AppDelegate.swift
//  cmus-swift
//
//  Created by Changyuan Lin on 12/3/20.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var stayOnTop: Bool = false
    var metadataData: MetadataData!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        metadataData = contentView.metadataData

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentAspectRatio = NSSize(width: 1, height: 1)
        window.isReleasedWhenClosed = false
        window.center()
//        window.setFrameAutosaveName("Main Window") // Disable autosave for now
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func stayOnTop(_ sender: NSMenuItem) {
        stayOnTop = !stayOnTop
        window.level = stayOnTop ? .floating : .normal
        sender.state = stayOnTop ? .on : .off
    }

    @IBAction func playPause(_ sender: NSMenuItem) {
        CmusRemote.playPause()
    }

    @IBAction func play(_ sender: NSMenuItem) {
        CmusRemote.play()
    }

    @IBAction func next(_ sender: NSMenuItem) {
        CmusRemote.next()
        metadataData.updateMetadata(timer: nil)
    }

    @IBAction func prev(_ sender: NSMenuItem) {
        CmusRemote.prev()
        metadataData.updateMetadata(timer: nil)
    }

    @IBAction func seek(_ sender: NSMenuItem) {
        CmusRemote.seek(seconds: sender.tag)
        metadataData.updateMetadata(timer: nil)
    }

}

