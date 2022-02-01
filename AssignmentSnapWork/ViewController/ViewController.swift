//
//  ViewController.swift
//  AssignmentSnapWork
//
//  Created by SMN Boy on 01/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel = ViewModel()
    
    @IBOutlet weak var selectYearLbl: UILabel!
    @IBOutlet weak var selectMonthLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var days = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        self.prepareTableView()
        
        
        selectYearLbl.isUserInteractionEnabled = true
        selectYearLbl.setCornerRadius(12)
        
        selectMonthLbl.isUserInteractionEnabled = true
        selectMonthLbl.setCornerRadius(12)
        
        let showMonthsGesture = UITapGestureRecognizer(target: self, action: #selector(self.showMonthBS(sender:)))
        selectMonthLbl.addGestureRecognizer(showMonthsGesture)
        
        let showYearGesture = UITapGestureRecognizer(target: self, action: #selector(self.showYearBS(sender:)))
        selectYearLbl.addGestureRecognizer(showYearGesture)
    }
    
    @objc func showMonthBS(sender: Any) {
        self.viewModel.showMonthBottomSheet(viewController: self)
    }
    
    @objc func showYearBS(sender: Any) {
        self.viewModel.showYearBottomSheet(viewController: self)
    }
    
    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerWithNib(nib: EventCell.self)
    }
}

extension ViewController: ViewModelDelegate {
    
    func onMonthSelected(year: Int, month: Int) {
        self.selectYearLbl.text = "\(year)"
        self.selectMonthLbl.text = ViewModel.getMonthName(month: month)
        let totalDays = viewModel.getDaysCount(year: year, month: month)
        self.days = Array(1...totalDays)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCell.self), for: indexPath) as! EventCell
        
        let day = self.days[indexPath.row]
        if let selectedYear = self.viewModel.selectedYear,
           let selectedMonth = self.viewModel.selectedMonth {
            
            cell.dayLbl.text = "\(day)\n\(ViewModel.getMonthName(month: selectedMonth))"
            
            let event = self.viewModel.retriveLocallyStoredEvent(day: day, month: selectedMonth, year: selectedYear)
            cell.configCell(event: event)
        } else {
            cell.configCell(event: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let day = self.days[indexPath.row]
        if let selectedYear = self.viewModel.selectedYear,
           let selectedMonth = self.viewModel.selectedMonth {
            
            let event = self.viewModel.retriveLocallyStoredEvent(day: day, month: selectedMonth, year: selectedYear) ??
            Event(time: "", day: day, month: selectedMonth, year: selectedYear, title: "", description: "")
            
            let vc = EventDetailController()
            vc.event = event
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            
        }
    }
}


extension ViewController: EventDetailControllerDelegate {
    func onSaveClicked(event: Event) {
        self.viewModel.storeEventLocally(event: event)
        self.tableView.reloadData()
    }
    
    func willDissmiss() {
        self.tableView.reloadData()
    }
}

