//
//  ViewController.swift
//  Alarm
//
//  Created by Wang Sheng Ping on 2021/1/7.
//

import UIKit

class ViewController: UIViewController {

//    MARK: - Properties

    var timeInfo = Time()
    var deleteIndex: Int = 0
    let mySections: [TableViewSection] = [.sleepWakeUp, .others]
    var times: [Time] = [] {
        didSet{
            saveData()
            times.sort(by: { $0.time < $1.time })
            alarmTableView.reloadData()
        }
    }
    
//    MARK: - IBOutlet
    
    @IBOutlet weak var alarmTableView: UITableView!
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviStatus()
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTableView.allowsSelection = false
        loadData()
        alarmTableView.allowsSelectionDuringEditing = false
    }
    
//    MARK: - Set Navigation Status
    
    func setNaviStatus() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = .orange
        self.navigationItem.title = "Alarm"
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
//    MARK: - Save & Load Data
    
    func saveData(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(times), forKey: "timeinfo")
    }
    
    func loadData(){
        if let data = UserDefaults.standard.value(forKey: "timeinfo") as? Data{
            let timeInfo2 = try? PropertyListDecoder().decode(Array<Time>.self, from: data)
            if let timeInfo2 = timeInfo2 {
                times = timeInfo2
            }
        }
    }
    
    
//    MARK: - Button
        
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        let editNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Navigation2") as! UINavigationController
        editNVC.viewControllers[0].title = "Add Alarm"
        let editVC = editNVC.viewControllers.first as! EditViewController
        editVC.timeInfoDelegate = self
        present(editNVC, animated: true, completion: nil)
        
        alarmTableView.setEditing(false, animated: true)
        super.setEditing(false, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        alarmTableView.setEditing(editing, animated: true)
    }
        
//    MARK: - Edit TableViewController
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch mySections[indexPath.section] {
        case .sleepWakeUp:
           return false
        case .others:
            alarmTableView.allowsSelectionDuringEditing = true
            return true
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            times.remove(at: indexPath.row)
        }
    }
}

//     MARK: - UITableViewControllerDelegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        mySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mySections[section] {
        case .sleepWakeUp: return 1
        case .others:      return times.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mySections[indexPath.section] {
        case .sleepWakeUp:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "No Alarm"
            cell.textLabel?.textColor = UIColor.gray
        
            return cell
        case .others:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCell2
                //待修改
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeStyle = .short
            let stringTime = dateFormatter.string(from: times[indexPath.row].time)
            cell.timeLabel.text = stringTime
            
            if times[indexPath.row].selectedWeek == "Weekdays"{
                cell.noteLabel.text = "\(times[indexPath.row].label), every weekday"
            }else if times[indexPath.row].selectedWeek == "Weekends"{
                cell.noteLabel.text = "\(times[indexPath.row].label), every weekend"
            }else{
                cell.noteLabel.text = "\(times[indexPath.row].label), \(times[indexPath.row].selectedWeek)"
            }
            
            let mySwitch = UISwitch(frame: .zero)
            mySwitch.isOn = true
//            mySwitch.addTarget(self, action: <#T##Selector#>, for: .valueChanged)
            cell.accessoryView = mySwitch
            cell.editingAccessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch mySections[indexPath.section]{
        
        case .others:
        let editNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Navigation2") as! UINavigationController
        
        editNVC.viewControllers[0].title = "Edit Alarm"
        let editVC = editNVC.viewControllers.first as! EditViewController
        editVC.timeInfoDelegate = self
            editVC.timeInfo.label = times[indexPath.row].label
        editVC.timeInfo.selectedDays = times[indexPath.row].selectedDays
            //待修改
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeStyle = .short
            let stringTime = dateFormatter.string(from: times[indexPath.row].time)
        editVC.timeString = stringTime
            
        editVC.editIndex = indexPath.row
        present(editNVC, animated: true, completion: nil)
            
        //點選後返回非編輯模式
        alarmTableView.setEditing(false, animated: true)
        super.setEditing(false, animated: true)
            
        default:
            break
        }
    }
    
    
//    MARK:- TableViewController Header
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let mySection = mySections[section]
        return mySection.headerTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

extension ViewController {
    
    enum TableViewSection {
        case sleepWakeUp, others
        
        var headerTitle: String {
            switch self {
            case .sleepWakeUp: return "Sleep|Wake Up"
            case .others:      return "Other"
            }
        }
    }
}

extension ViewController: SendTimeInfoDelegate{
    func timeInfo(timeData: Time) {
        times.append(timeData)
    }
    func editInfo(timeData: Time, index: Int) {
        times[index] = timeData
    }
    func deleteIndex(index: Int) {
        deleteIndex = index
        times.remove(at: index)
    }
}
