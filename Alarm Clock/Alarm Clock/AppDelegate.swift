import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    let alarmManager = AlarmManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Add the .resizable flag to the window style
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], // Notice the addition of .resizable here
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.delegate = self // Make sure to set the delegate if you want to use delegate methods
        window.makeKeyAndOrderFront(nil)

        let contentView = ContentView(alarmManager: self.alarmManager)
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    @objc func windowDidResize(_ notification: Notification) {
        print("Window did resize to: \(window.frame.size)")
    }
}
