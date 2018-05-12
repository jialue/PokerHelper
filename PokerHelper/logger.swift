//
//  logger.swift
//  PokerHelper
//
//  Created by Jialue Huang on 10/05/2018.
//  Copyright © 2018 Jialue Huang. All rights reserved.
//

import Foundation

func local_error(message: String = "", file: String = #file, method: String = #function, line: Int = #line) -> Void {
    print("\((file as NSString).lastPathComponent)[\(line)], \(method), \(message)")
}


func local_debug<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) -> Void {
    print("\((file as NSString).lastPathComponent)[\(line)], \(method), \(message)")
}
