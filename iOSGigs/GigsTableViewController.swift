//
//  GigsTableViewController.swift
//  iOSGigs
//
//  Created by Dongwoo Pae on 5/30/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {

    var gigController = GigController()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          if self.gigController.bearer == nil {
            performSegue(withIdentifier: "ToLoginVC", sender: self)
          } else {
            
            self.gigController.fetchGigs { (error) in
                if let error = error {
                    
                    return
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return self.gigController.gigs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let gig = self.gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        cell.detailTextLabel?.text = df.string(from: gig.dueDate)
        return cell
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGig" {
            guard let destVC = segue.destination as? GigsDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow else {return}
                destVC.gigController = self.gigController
                destVC.gig = self.gigController.gigs[selectedRow.row]
        } else if segue.identifier == "AddGig" {
            guard let desVC = segue.destination as? GigsDetailViewController else {return}
                desVC.gigController = self.gigController
        } else if segue.identifier == "ToLoginVC" {
            guard let destVC = segue.destination as? LoginViewViewController else {return}
                destVC.gigController = self.gigController
        }
    }
    
    

}
