//
//  Bundle+Extension.swift
//  DownloadManager
//
//  Created by sy on 10/4/21.
//

import Foundation

extension Bundle {
    
    private var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    private var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    var bundleID: String {
        return Bundle.main.bundleIdentifier?.lowercased() ?? ""
    }
    
    var versionString: String {
        var strType: String = ""

        // If you use different bundle IDs for different environments, code like this is helpful:
        if bundleID.contains(".idms") {
            print(strType)
            strType = "Release"
        }
        
        let returnValue = "Version: \(releaseVersionNumber) (Build \(buildVersionNumber))"
        
        return returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}// end of extension
