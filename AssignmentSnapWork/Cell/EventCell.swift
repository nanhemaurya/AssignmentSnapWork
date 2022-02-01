//
//  EventCell.swift
//  AssignmentSnapWork
//
//  Created by SMN Boy on 01/02/22.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(event: Event?) {
        if let event = event {
            titleLbl.text = event.title
            descriptionLbl.text = event.description
        } else {
            titleLbl.text = ""
            descriptionLbl.text = ""
        }
    }
    
}
