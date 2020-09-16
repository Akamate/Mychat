//
//  NewMessageViewController.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 9/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMsgDelegate : class {
    func controller (controller : NewMessageViewController,startMsgWith user : UserProfile)
}

class NewMessageViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    private var users = [UserProfile]()
    weak var delegate : NewMsgDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        fetchUsers()
        // Do any additional setup after loading the view.
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        let apperance = UINavigationBarAppearance()
        apperance.titleTextAttributes = [.foregroundColor : UIColor.white]
        apperance.backgroundColor = .systemGreen
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func configureTableView() {
        userTableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tableFooterView = UIView()
        userTableView.rowHeight = 80
    }
    
    func fetchUsers() {
        UserService.shared.fetchAllUsers { (users) in
            self.users = users
            self.userTableView.reloadData()
        }
    }
}

extension NewMessageViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userTableView.deselectRow(at: indexPath, animated: true)
//        navigationController?.popViewController(animated: true)
        delegate?.controller(controller: self, startMsgWith: users[indexPath.row])
    }
}

extension NewMessageViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    
}
