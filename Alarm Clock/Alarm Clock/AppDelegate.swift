//
//  AppDelegate.swift
//  Alarm Clock
//
//  Created by . . on 09/04/2024.
//

import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    let alarmManager = AlarmManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Remove the .resizable flag from the window style
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.makeKeyAndOrderFront(nil)

        let contentView = ContentView(alarmManager: self.alarmManager)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    @objc func windowDidResize(_ notification: Notification) {
        print("Window did resize to: \(window.frame.size)")
    }
}
