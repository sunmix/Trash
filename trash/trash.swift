//
//  trash.swift
//  trash
//
//  Created by Ming on 16/04/13.
//  Copyright © 2016年 sunmix. All rights reserved.
//

import Foundation

func askFinderToTrashFiles(urls: [NSURL]) -> Int32 {
    
    let finder = NSAppleEventDescriptor(bundleIdentifier: "com.apple.finder")
    let fileList = NSAppleEventDescriptor.listDescriptor()
    
    for (i, url) in urls.enumerate() {
        fileList.insertDescriptor(NSAppleEventDescriptor(fileURL: url),
                                  atIndex: (i + 1))
    }
    
    let event = NSAppleEventDescriptor(eventClass: UInt32(kAECoreSuite),
                                       eventID: UInt32(kAEDelete),
                                       targetDescriptor: finder,
                                       returnID: Int16(kAutoGenerateReturnID),
                                       transactionID: Int32(kAnyTransactionID))
    
    event.setDescriptor(fileList, forKeyword: UInt32(keyDirectObject))
    
    do {
        let reply = try event.sendEventWithOptions(.WaitForReply, timeout: 0)
        if reply.paramDescriptorForKeyword(UInt32(keyErrorNumber))!.int32Value > 0 {
            print("reply = \(reply)")
            return EXIT_FAILURE
        }
    } catch {
        print(error)
        return EXIT_FAILURE
    }
    
    return EXIT_SUCCESS
}

func getFinder() -> AnyObject? {
    return SBApplication(bundleIdentifier: "com.apple.finder")
}

func askFinderToEmptyTrash() -> Int32 {
    guard let finder = getFinder() else {
        return EXIT_FAILURE
    }
    finder.trash!.emptySecurity(false)
    return EXIT_SUCCESS
}