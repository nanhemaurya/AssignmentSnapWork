//
//  ViewModel.swift
//  AssignmentSnapWork
//
//  Created by SMN Boy on 01/02/22.
//

import Foundation
import UIKit

struct Event: Codable {
    var time: String
    let day: Int
    let month: Int
    let year: Int
    var title: String
    var description: String
}

protocol ViewModelDelegate {
    func onMonthSelected(year: Int, month: Int)
}

class ViewModel {
    
    static func getMonthName(month: Int) -> String {
        return self.months[month - 1]
    }
    
    static private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    
    var selectedYear: Int? = nil
    var selectedMonth: Int? = nil
    
    var delegate: ViewModelDelegate? = nil
    
    func getYears() -> [Int] {
        return Array(2016...2025)
    }
    
    func getMonths() -> [Int] {
        return Array(1...12)
    }
    
   
    func getDaysCount(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    
    func showYearBottomSheet(viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: "Year", preferredStyle: .actionSheet)
        
        self.getYears().forEach { year in
            alert.addAction(UIAlertAction(title: "\(year)", style: .default, handler: { (_) in
                self.selectedYear = year
                self.showMonthBottomSheet(viewController: viewController)
            }))
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func showMonthBottomSheet(viewController: UIViewController) {
        if selectedYear == nil {
            self.showYearBottomSheet(viewController: viewController)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Month", preferredStyle: .actionSheet)
        
        self.getMonths().enumerated().forEach { (index, month) in
            let monthName = ViewModel.months[index]
            alert.addAction(UIAlertAction(title: monthName, style: .default, handler: { (_) in
                self.selectedMonth = month
                self.delegate?.onMonthSelected(year: self.selectedYear!, month: month)
            }))
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func genIdentifierOrKey(day: Int, month: Int, year: Int) -> String {
        return "\(day)-\(month)-\(year)"
    }
    
    
    func storeEventLocally(event: Event) {
        let key = self.genIdentifierOrKey(day: event.day, month: event.month, year: event.year)
        let value = self.encodeModelToStore(event: event)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func retriveLocallyStoredEvent(day: Int, month: Int, year: Int) -> Event? {
        let key = self.genIdentifierOrKey(day: day, month: month, year: year)
        guard let encodedString = UserDefaults.standard.string(forKey: key) else {
            return nil
        }
        return self.decodeModelFromStore(encodedString: encodedString)
    }
    
    
    private func encodeModelToStore(event: Event) -> String? {
        guard let jsonData = try? JSONEncoder().encode(event) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    private func decodeModelFromStore(encodedString: String) -> Event? {
        guard let data = encodedString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Event.self, from: data)
    }
    
    
    
}
