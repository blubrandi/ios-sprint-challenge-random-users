//
//  UserController.swift
//  Random Users
//
//  Created by Brandi on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    var users: [User] = []
    
    func getUsers(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        URLSession.shared.dataTask(with: baseURL.appendingPathComponent("json")) { (data, _, error) in
            
            if let error = error {
                print("There was an error in \(#function) on line \(#line) in \(#file)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("There was an error in \(#function) on line \(#line) in \(#file)")
                completion(NSError())
                return
            }
            
            do {
                let users = Array(try JSONDecoder().decode([String: User].self, from: data).values)
                
                self.users = users
                completion(nil)
            } catch {
                print("There was an error in \(#function) on line \(#line) in \(#file)")
                completion(error)
            }
            
        }.resume()
    }
}
