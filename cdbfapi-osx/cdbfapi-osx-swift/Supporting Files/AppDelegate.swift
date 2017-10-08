//
//  AppDelegate.swift
//  cdbfapi-osx-swift
//
//  Created by Sergey Chehuta on 26/09/2017.
//  Copyright © 2017 WhiteTown. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    internal func applicationShouldTerminateAfterLastWindowClosed(_ application: NSApplication) -> Bool
    {
        return true
    }

}

