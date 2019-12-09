//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Brandi on 12/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var userController: UserController?
    var user: User?
    
    private let cache = Cache<String, Data>()
    private let imageFetchQueue = OperationQueue()
    private var operations = [String : Operation]()
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()

    }
    

    private func updateViews() {
        guard let user = user else { return }
        
        do {
            let data = try Data(contentsOf: user.image)
            userImage.image = UIImage(data: data)
        } catch {
            print("There's an error here.")
        }
        
        userNameLabel.text = user.name
        userPhoneLabel.text = user.phone
        userEmailLabel.text = user.email
    }
    

}
