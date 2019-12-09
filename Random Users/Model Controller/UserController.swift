//
//  UserController.swift
//  Random Users
//
//  Created by Brandi on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping (Error?) -> Void = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("There was an error in \(#function), on line \(#line), in \(#file).")
                completion(error)
                return
            }
            guard let data = data else {
                print("There was an error in \(#function), on line \(#line), in \(#file).")
                completion(nil)
                return
            }
            do {
                let newUser = try JSONDecoder().decode(Users.self, from: data)
                self.users = newUser.results
            } catch {
                print("There was an error in \(#function), on line \(#line), in \(#file).")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
}
