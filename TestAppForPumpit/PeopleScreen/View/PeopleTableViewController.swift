//
//  PeopleViewController.swift
//  TestAppForPumpit
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PeopleTableViewController: UITableViewController {
    
    var peoples: [Peoples] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observePeoples()

        tableView.tableFooterView = UIView() //delete lines in empty cells
        tableView.separatorInset = UIEdgeInsets.zero //full screen width separator
        
    }
    
//MARK: - Ref to database
    
    func observePeoples() {
        let peoplesRef = Database.database().reference().child("user_id").child("people")
        
        peoplesRef.observe(.value) { (snapshot) in
            
            var tempPeoples = [Peoples]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let name = dict["name"] as? String,
                    let id = dict["id"] as? String,
                    let batteryLevel = dict["battery_level"] as? String,
                    let status = dict["status"] as? String,
                    let photo = dict["photo"] as? String,
                    let url = URL(string: photo)
                {
                    let peoplesDB = Peoples(id: id, name: name, batteryLevel: batteryLevel, status: status, photoURL: url)
                    tempPeoples.append(peoplesDB)
                }
            }
            self.peoples = tempPeoples
            self.tableView.reloadData()
        }
    }
    
//MARK: - Setup table
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! CustomTableViewCell
        
        cell.set(peoples: peoples[indexPath.row])
        
        return cell
    }

//MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
}
