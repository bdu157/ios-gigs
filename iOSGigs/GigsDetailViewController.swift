//
//  ViewController.swift
//  iOSGigs
//
//  Created by Dongwoo Pae on 5/30/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        if gig == nil {
              guard let title = titleTextField.text,
                let dates = datePicker?.date,
                let description = descriptionTextView.text else {return}
            gigController.CreateGig(title: title, description: description, dueDate: dates) { (error) in
                if let error = error {
                    NSLog("Error : \(error)")
                    return
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else if gig != nil {
            navigationController?.popViewController(animated: true)
        }
    }
 
    
    func updateViews() {
        if let gig = gig {
            titleTextField.text = gig.title
            datePicker.date = gig.dueDate
            descriptionTextView.text = gig.description
            navigationItem.title = "View Gig"
        } else {
            navigationItem.title = "New Gig"
        }
    }
}

