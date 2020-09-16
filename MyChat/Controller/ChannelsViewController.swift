//
//  ViewController.swift
//  MyChat
//
//  Created by Aukmate  Chayapiwat on 8/9/2563 BE.
//  Copyright © 2563 Aukmate  Chayapiwat. All rights reserved.
//

import UIKit
import Firebase
class ChannelsViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    private var userProfile : UserProfile?
    private var channels = [Channel]()
    private var channelDict = [String : Channel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginCheck()
        configureNavigationBar()
        configureTableView()
        fetchChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    func fetchChannels() {
        MessageService.shared.fetchAllChannels { (channels) in
            print(channels.count)
            channels.forEach { (channel) in
                let msg = channel.message
                self.channelDict[msg.toUserId] = channel
            }
            self.channels = Array(self.channelDict.values)
            self.tableView.reloadData()
        }
    }
    
    func loginCheck() {
        if (Auth.auth().currentUser?.uid == nil) {
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "loginViewController")
            let nav = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.rootViewController = nav
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    
    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
//        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        let apperance = UINavigationBarAppearance()
        apperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        apperance.titleTextAttributes = [.foregroundColor : UIColor.white]
        apperance.backgroundColor = .systemGreen
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        navigationController?.navigationBar.compactAppearance = apperance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func configureTableView(){
        tableView.rowHeight = 80
      //  tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "channelCell")
            
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToNewMsg"){
            let viewController = segue.destination as! NewMessageViewController
            viewController.delegate = self
        }
        else {
            let vc = segue.destination as! ChatViewController
            if let user = userProfile {
                vc.user = user
            }
        }
    }
    @IBAction func signOutHandle(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            loginCheck()
        }catch {
            print("signout error")
        }
        
    }
}

extension ChannelsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        self.userProfile = channels[indexPath.row].user
        performSegue(withIdentifier: "goToMsg", sender: nil)        
    }
}

extension ChannelsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelCell
        cell.channel = channels[indexPath.row]
        return cell
    }
    
}

extension ChannelsViewController : NewMsgDelegate {
    func controller(controller: NewMessageViewController, startMsgWith user: UserProfile) {
        //gotoMsgController
        self.userProfile = user
        navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "goToMsg", sender: nil)
    }
}
