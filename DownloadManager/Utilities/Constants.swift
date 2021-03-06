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
    
    struct Images {
        static let Logout = "logout-icon.png"
        static let DownloadManagerLogo = "DownloadManagerLogo.png"
    }
    
    enum Colors: String {
        case primaryColor
    }
    
    enum AlertActionTypes {
        case OK
        case Cancel
    }
    
    enum AlertMessages {
        case DownloadError
        case DownloadSuccess
        case ConnectionError
        case NoInternetConnection
        case ContinueWithNoInternet
        case Logout
        case CopyAndOpenURL
        
        var stringValue: String {
            switch self {
            case .DownloadError: return "Photo could not be downloaded. Try again."
            case .DownloadSuccess: return "Photo has been downloaded to your Photo Album."
            case .ConnectionError: return "Connection Error"
            case .NoInternetConnection: return "Please check your internet connection"
            case .ContinueWithNoInternet: return "No internet connection. Do you want to continue with cached data?"
            case .Logout: return "Are you sure you want to logout?"
            case .CopyAndOpenURL: return "URL has been copied successfuly! Do you want to open the link to Safari?"
                
            }
        }
    }
}
