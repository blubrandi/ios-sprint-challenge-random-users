//
//  RandomUsersTableViewController.swift
//  Random Users
//
//  Created by Brandi on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewController: UITableViewController {
    
    private let userController = UserController()
    private let cache = Cache<String, Data>()
    private let imageFetchQueue = OperationQueue()
    private var operations = [String : Operation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUsers { (error) in
            if error != nil {
                print("There was an error in \(#function), on line \(#line), in \(#file).")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        let user = userController.users[indexPath.row]
        cell.textLabel?.text = user.name
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowUserDetailSegue" {
            guard let destinationVC = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let user = userController.users[indexPath.row]
            
            destinationVC.user = user
            destinationVC.userController = userController
            
        }
    }
    
    
    // MARK: - Private
    
    func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let user = userController.users[indexPath.row]
        
        if let cachedData = cache.value(key: user.email),
            // turn data into UIImage
            let image = UIImage(data: cachedData) {
            cell.imageView?.image = image
            return
        }
        
        let fetchOp = FetchImageOperation(user: user)
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(key: user.email, value: data)
            }
        }
        
        let completionOP = BlockOperation {
            
            defer { self.operations.removeValue(forKey: user.email) }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                print("Got image for reused cell")
                return
            }
            
            if let data = fetchOp.imageData {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOP.addDependency(fetchOp)
        imageFetchQueue.addOperation(fetchOp)
        imageFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOP)
        
        operations[user.email] = fetchOp
    }
}
