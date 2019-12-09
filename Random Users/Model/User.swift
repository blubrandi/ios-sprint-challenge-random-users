//
//  User.swift
//  Random Users
//
//  Created by Brandi on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {

    var results: [User]

    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([User].self, forKey: .results)
        self.results = results
    }
}

struct User: Decodable {
    
    var phone: String
    var name: String
    var email: String
    var image: String
    var imageThumbnail: String
    
    enum UserCodingKeys: String, CodingKey {
        case phone
        case name
        case email
        case image
        case imageThumbnail
    }
    
    enum NameCodingKeys: String, CodingKey {
        case firstName
        case lastName
    }
    
    enum ImageCodingKeys: String, CodingKey {
        case medium
        case thumbnail
    }
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        self.phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        
        let firstName = try nameContainer.decode(String.self, forKey: .firstName)
        let lastName = try nameContainer.decode(String.self, forKey: .lastName)
        
        self.name = "\(firstName) \(lastName)"
        
        self.email = try container.decode(String.self, forKey: .email)
        
        let imageContainer = try container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        
        self.image = try imageContainer.decode(String.self, forKey: .medium)
        self.imageThumbnail = try imageContainer.decode(String.self, forKey: .thumbnail)

    }
    
}
