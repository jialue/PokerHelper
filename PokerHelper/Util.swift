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
    class HttpRequest {
        var _method: String = String()
        var _requestURI: String = String()
        var _headers: Dictionary<String, String> = Dictionary()
        var _body: String = String()
        var _version: String = String()
        init(method: String, requestURI: String) {
            _method = method
            _requestURI = requestURI
            _version = "1.1"
        }
        init(method: String, requestURI: String, requestData: Proto_GameData) {
            _method = method
            _requestURI = requestURI
            _version = "1.1"
            let json = try! requestData.jsonString()
            setBody(body: json)
        }
        public func addHeader(header: String, content: String) {
            _headers[header] = content
        }
        public func setBody(body: String) {
            _body = body
        }
        public func generatHttpRequest() -> String {
            var retval: String = String()
            retval += _method + " " + _requestURI + " " + "HTTP/" + _version + "\r\n"
            for header in _headers {
                retval += header.key + ": " + header.value + "\r\n"
            }
            if (!_body.isEmpty) {
                retval += "Content-Length: " + String(_body.characters.count) + "\r\n"
            }
            retval += "\r\n"
            retval += _body
            print(retval)
            return retval
        }
    }
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
