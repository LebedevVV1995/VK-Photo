//
//  ViewController.swift
//  VK-Photo
//
//  Created by Владимир on 05.04.2022.
//  Copyright © 2022 Владимир. All rights reserved.
//

import UIKit
import JGProgressHUD

struct SearchResult {
    let name: String
    let email: String
}
class AllUsersViewController: UIViewController {
    public var completion: ((SearchResult) -> (Void))?
    private let spinner = JGProgressHUD(style: .dark)
    private var users = [[String: String]]()
    private var results = [SearchResult]()
    private var hasFetched = false

    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(NewPhotoUserCell.self,
                       forCellReuseIdentifier: NewPhotoUserCell.identifire)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        searchUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension AllUsersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewPhotoUserCell.identifire, for: indexPath) as! NewPhotoUserCell
        cell.configure(with: model)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func searchUsers() {
        //check if array has firebase results
        //if hasFetched {
            DatabaseManeger.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers()
                    self!.updateUI()
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        
    }
    
    func filterUsers() {
        //update the UI: eitehr show results or show no results label
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        let safeEmail = DatabaseManeger.safeEmail(emailAddress: currentUserEmail)

        self.spinner.dismiss()

        let results: [SearchResult] = self.users.filter({
            guard let email = $0["email"], email != safeEmail else {
                    return false
            }

            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix("")
        }).compactMap({
            guard let email = $0["email"],
                let name = $0["name"] else {
                    return nil
            }
            return SearchResult(name: name, email: email)
        })
        self.results = results
        updateUI()
    }
    func updateUI() {
        if results.isEmpty {
            self.tableView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}


