//
//  RepeatViewController.swift
//  Alarm
//
//  Created by Wang Sheng Ping on 2021/1/12.
//

import UIKit

protocol SendWeekIndexDelegate {
    func weekIndex(data: Set<WeekDay>)
}

class RepeatViewController: UIViewController, UITableViewDelegate {

    var timeInfo = Time()
    var delegate: SendWeekIndexDelegate?
    @IBOutlet weak var repeatTableView: UITableView!
    var weekArr = Set<String>()
    
//    MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repeatTableView.delegate = self
        repeatTableView.dataSource = self
        repeatTableView.tableFooterView = UIView(frame: .zero)
        repeatTableView.isScrollEnabled = false
        repeatTableView.allowsMultipleSelection = true
        navigationItem.title = "Repeat"
    }
    
    
//    MARK: - Pass information to last page
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.weekIndex(data: timeInfo.selectedDays)
            }
    }

//MARK: - UITableViewDataSource & UITableViewDelegate

extension RepeatViewController: UITabBarDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(WeekDay.allCases[indexPath.row])"
        cell.textLabel?.textColor = .white
        cell.tintColor = .orange
        
        cell.accessoryType = timeInfo.selectedDays.contains(WeekDay.allCases[indexPath.row]) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDays = WeekDay.allCases[indexPath.row]
        if timeInfo.selectedDays.contains(selectedDays){
            timeInfo.selectedDays.remove(selectedDays)
        }else{
            timeInfo.selectedDays.insert(selectedDays)
        }
        repeatTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
