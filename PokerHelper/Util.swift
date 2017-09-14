//
//  utils.swift
//  PokerHelper
//
//  Created by Jialue Huang on 9/14/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import Foundation
import SwiftSocket

struct Util {
    
}

extension Util {
    class ServerUtil {
        static public func sendRequest(string: String, using client: TCPClient) {
            print("Sending data ... ")
            
            switch client.send(string: string) {
            case .success:
//                return readResponse(from: client)
                if let response = readResponse(from: client) {
                    print("Response: \(response)")
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        static public func readResponse(from client: TCPClient) -> String? {
            guard let response = client.read(1024*10, timeout:10) else { return nil }
            
            return String(bytes: response, encoding: .utf8)
        }
    }
}
