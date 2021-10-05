//
//  Constants.swift
//  DownloadManager
//
//  Created by sy on 10/4/21.
//

import Foundation

class Constants {
 
    struct Fonts {
        static let MontserratBoldFont = "Montserrat-Bold"
        static let MontserratRegularFont = "Montserrat-Regular"
        static let MontserratLightFont = "Montserrat-Light"
    }
    
    enum AlertActionTypes {
        case OK
        case Cancel
    }
    
    enum AlertMessages {
        case DownloadError
        case DownloadSuccess
        
        var stringValue: String {
            switch self {
            case .DownloadError: return "Photo could not be downloaded. Try again."
            case .DownloadSuccess: return "Photo has been downloaded to your Photo Album."
            }
        }
    }
}
