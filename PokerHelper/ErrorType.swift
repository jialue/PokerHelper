//
//  ErrorType.swift
//  PokerHelper
//
//  Created by Jialue Huang on 11/05/2018.
//  Copyright © 2018 Jialue Huang. All rights reserved.
//

import Foundation

enum GameError: Error {
//    case ErrorState(errorCode: Int, errorReason: String)
    case AddPlayerError(error: String)
    case Generic(error: String)
}
