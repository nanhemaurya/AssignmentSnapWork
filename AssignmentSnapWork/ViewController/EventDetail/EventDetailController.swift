//
//  EventDetailController.swift
//  AssignmentSnapWork
//
//  Created by SMN Boy on 01/02/22.
//

import UIKit

protocol EventDetailControllerDelegate {
    func onSaveClicked(event: Event)
    
    func willDissmiss()
    
}

class EventDetailController: UIViewController {
    
    var delegate: EventDetailControllerDelegate? = nil
    
    var event: Event!
    
    @IBOutlet weak var backBtn: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateAndTimeInput: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var saveBtnLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateLbl.text = "\(self.event.day)-\(ViewModel.getMonthName(month: self.event.month))-\(self.event.year)"
        
        self.dateAndTimeInput.text = self.event.time
        self.descTextView.text = self.event.description
        self.titleTextField.text = self.event.title
        
        let saveGesture = UITapGestureRecognizer(target: self, action: #selector(self.saveEvent(sender:)))
        saveBtnLbl.isUserInteractionEnabled = true
        saveBtnLbl.addGestureRecognizer(saveGesture)
        
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(self.backBtn(sender:)))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(backGesture)
    }
    
    @objc func saveEvent(sender: Any) {
        self.event.time = dateAndTimeInput.text ?? ""
        self.event.title = titleTextField.text ?? ""
        self.event.description = descTextView.text ?? ""
        
        delegate?.onSaveClicked(event: self.event)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backBtn(sender: Any) {
        delegate?.willDissmiss()
        self.dismiss(animated: true, completion: nil)
    }
}
