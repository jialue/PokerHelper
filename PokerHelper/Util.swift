//
//  utils.swift
//  PokerHelper
//
//  Created by Jialue Huang on 9/14/17.
//  Copyright © 2017 Jialue Huang. All rights reserved.
//

import Foundation
import SwiftSocket
import SwiftyJSON

struct Util {
    static public func dateNowAsString() -> String {
        let nowDate = Date()
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = formatter.string(from: nowDate)
//        return date.components(separatedBy: " ").first!
        return date
    }
}


extension String {
    func find(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index {
        return (self.range(of: input, options: options)?.lowerBound)!
    }
    func lastIndex(of string: String) -> Int? {
        guard let index = range(of: string, options: .backwards) else { return nil }
        return self.distance(from: self.startIndex, to: index.lowerBound)
    }
//    func find_last(_ input: String) -> String.Index? {
//        return indexOf(input, options: .backwards)
//    }
}

extension Util {
    class DealerServerRequest {
        var _header: JSON = JSON()
        var _body: JSON = JSON()
        var _request: JSON = JSON()
        init(service: String, jsonString: String) {
            let message: JSON = JSON.init(parseJSON: jsonString)
            _header["service"].string = service
            _body["message"].object = message
            _request["header"].object = _header
            _request["body"].object = _body
        }
        
        init(service: String, json: JSON) {
            _header["service"].string = service
            _body["message"] = json
            _request["header"].object = _header
            _request["body"].object = _body
        }
        
        func toString() -> String {
            return _request.rawString()!
        }
    }
    
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
        
        init(method: String, requestURI: String, jsonString: String) {
            _method = method
            _requestURI = requestURI
            _version = "1.1"
            setBody(body: jsonString)
        }
        
        init(method: String, requestURI: String, json: JSON) {
            _method = method
            _requestURI = requestURI
            _version = "1.1"
            setBody(body: json.rawString()!)
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
        
        static public func sendRequest(string: String, using client: TCPClient, completion: (_ message: String) -> Void) {
            print("Sending data ... ")
            
            switch client.send(string: string) {
            case .success:
                if let response = readResponse(from: client) {
                    print("Response: \(response)")
                    let index = response.find("\r\n\r\n")
                    let start = response.index(index, offsetBy: 2)
                    let body = String(response[start...])
                    completion(body)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        static public func sendRequest(string: String, using client: TCPClient, completion: (_ message: String) throws -> Void) throws {
            print("Sending data ... ")
            
            switch client.send(string: string) {
            case .success:
                if let response = readResponse(from: client) {
                    print("Response: \(response)")
                    let index = response.find("\r\n\r\n")
                    let start = response.index(index, offsetBy: 2)
                    let body = String(response[start...])
                    try completion(body)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        static public func sendRequest(request: DealerServerRequest, using client: TCPClient, completion: (_ message: String) -> Void) {
            print("Sending data ... ")
            
            switch client.send(string: request.toString()) {
            case .success:
                if let response = readResponse(from: client) {
                    print("Response: \(response)")
                    completion(response)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        static public func sendRequest(request: DealerServerRequest, using client: TCPClient, completion: (_ message: String) throws -> Void) throws {
            print("Sending data ... ")
            
            switch client.send(string: request.toString()) {
            case .success:
                if let response = readResponse(from: client) {
                    print("Response: \(response)")
                    try completion(response)
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
