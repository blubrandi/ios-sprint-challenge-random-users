//
//  User.swift
//  Random Users
//
//  Created by Brandi on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Codable {
    
    var results: [User]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct User: Codable {
    
    var phone: String
    var name: String
    var email: String
    var image: URL
    
    enum UserCodingKeys: String, CodingKey {
        case phone
        case name
        case email
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case first
            case last
        }
        
        enum ImageCodingKeys: String, CodingKey {
            case medium
            case thumbnail
        }
        
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        let phone = try container.decode(String.self, forKey: .phone)
        self.phone = phone
        
        let nameContainer = try container.nestedContainer(keyedBy: UserCodingKeys.NameCodingKeys.self, forKey: .name)
        
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        let name = "\(firstName) \(lastName)"
        self.name = name
        
        self.email = try container.decode(String.self, forKey: .email)
        
        let imageContainer = try container.nestedContainer(keyedBy: UserCodingKeys.ImageCodingKeys.self, forKey: .picture)
        
        self.image = try imageContainer.decode(URL.self, forKey: .medium)
    }
    
}

