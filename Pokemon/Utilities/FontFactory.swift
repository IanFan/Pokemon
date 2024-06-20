//
//  FontFactory.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

enum FontEnum: String {
    case DEFAULT
    case Helvetica
    case HelveticaBold
    case HelveticaNeue
    case HelveticaNeueMedium
    case HelveticaNeueBold
    case HelveticaNeueBoldItalic
    
    case PingFangTCMedium
    case PingFangTCRegular
    
    init?(rawValue _: String) {
        return nil
    }

    var rawValue: String {
        switch self {
        case .DEFAULT: return "DEFAULT"
        case .Helvetica: return "Helvetica"
        case .HelveticaBold: return "Helvetica-Bold"
        case .HelveticaNeue: return "HelveticaNeue"
        case .HelveticaNeueMedium: return "HelveticaNeue-Medium"
        case .HelveticaNeueBold: return "HelveticaNeue-Bold"
        case .HelveticaNeueBoldItalic: return "HelveticaNeue-BoldItalic"
            
        case .PingFangTCMedium: return "PingFang-TC-Medium"
        case .PingFangTCRegular: return "PingFang-TC-Regular"
        }
    }
}

