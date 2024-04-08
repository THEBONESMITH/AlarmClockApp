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
    let alarmManager = AlarmManager() // Create an instance of AlarmManager

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.minSize = NSSize(width: 600, height: 400)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.makeKeyAndOrderFront(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let contentView = ContentView(alarmManager: self.alarmManager)
            self.window.contentView = NSHostingView(rootView: contentView)
        }
    }
    
    @objc func windowDidResize(_ notification: Notification) {
        print("Window did resize to: \(window.frame.size)")
    }
}
