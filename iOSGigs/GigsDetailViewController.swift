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
            loadViewIfNeeded()
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
                let description = descriptionTextView.text,
                let date = datePicker?.date else {return}
           self.gigController.CreateGig(title: title, description: description, dueDate: date) { (error) in
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
        if let gigsss = gig {
            titleTextField.text = gigsss.title
            datePicker.date = gigsss.dueDate
            descriptionTextView.text = gigsss.description
            navigationItem.title = "View Gig"
        } else {
            navigationItem.title = "New Gig"
        }
    }
}

