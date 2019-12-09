//
//  Utilities.swift
//  Random Users
//
//  Created by Brandi on 12/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}