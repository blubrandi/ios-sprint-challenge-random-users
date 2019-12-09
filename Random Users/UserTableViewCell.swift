//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Brandi on 12/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let user = user else { return }
        userName.text = user.name
    }
}
