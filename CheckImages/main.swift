//
//  main.swift
//  CheckImages
//
//  Created by Andre Salla on 08/03/17.
//  Copyright © 2017 Andre Salla. All rights reserved.
//

import Foundation

if CommandLine.arguments.count < 3 {
    exit(-100)
}

var enumPath = CommandLine.arguments[1]
var assetPath = CommandLine.arguments[2]
var path = CommandLine.arguments[3]

let check = CheckImages()
check.check(filePathEnum: enumPath, filePathAssets: assetPath, filePath: path)
exit(EXIT_SUCCESS)
