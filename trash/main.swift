//
//  main.swift
//  trash
//
//  Created by Ming on 16/04/10.
//  Copyright © 2016年 sunmix. All rights reserved.
//

import Foundation

let args = Process.arguments.dropFirst()
guard args.count > 0 else {
    exit(EXIT_FAILURE)
}

switch args.first! {
case "-e":
    exit(askFinderToEmptyTrash())
default:
    let urls = args.map {
        NSURL(fileURLWithPath: ($0 as NSString).stringByExpandingTildeInPath)
    }
    exit(askFinderToTrashFiles(urls))
}
