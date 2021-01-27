//
//  EditViewController.swift
//  Alarm
//
//  Created by Wang Sheng Ping on 2021/1/7.
//

import UIKit

protocol SendTimeInfoDelegate {
    func timeInfo(timeData: Time)
    func editInfo(timeData: Time, index: Int)
    func deleteIndex(index: Int)
}

class EditViewController: UIViewController {
        
//    MARK: - Properties
    
    var myRows : [EditRows] = [.repeatRow, .labelRow, .soundLabel, .snoozeLabel]
    var mySections : [EditSections] = [.edit, .delete]
    var editBool: Bool = false
    var editIndex: Int = 0 {
        didSet{
            editBool = true
        }
    }
    var timeString: String = ""
    var timeInfoDelegate: SendTimeInfoDelegate?
    var timeInfo = Time()
    
//    MARK: - IBOutlet
    
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
//     MARK: - Set back button
    
    func setBackBtn() {
        let backBtn = UIBarButtonItem()
        backBtn.title = "Back"
        backBtn.tintColor = .orange
        navigationItem.backBarButtonItem = backBtn
    }
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.isScrollEnabled = false
        timePicker.becomeFirstResponder()
        timePicker.tintColor = .orange
        setNaviItem()
        setTimePicker()
    }
    
//    MARK: - Set Navigation Item
    
    func setNaviItem() {
        navigationItem.leftBarButtonItem?.tintColor = .orange
        navigationItem.rightBarButtonItem?.tintColor = .orange
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
//    MARK: - Buttons
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        setTimePicker()
        if editBool == true{
            timeInfoDelegate?.editInfo(timeData: timeInfo, index: editIndex)
        }else{
        timeInfoDelegate?.timeInfo(timeData: timeInfo)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //  MARK: - Picker

    func setTimePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timePicker.datePickerMode = .time
        dateFormatter.timeStyle = .short
        timeInfo.time = timePicker.date
        
        //檢查是否有傳值進來
        if timeString == ""{
            timePicker.date = Date()
        }else{
            timePicker.date = dateFormatter.date(from: timeString)!
        }
    }
}

//  MARK: - TableVIewDataSource. TableViewDelegate

extension EditViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if editBool == true{
            return mySections.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mySections[section]{
        case .edit:
            return timeInfo.infoArray.count
            
        case .delete:
        return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mySections[indexPath.section]{

        case .edit:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = timeInfo.infoArray[indexPath.row]
            cell.textLabel?.textColor = .white
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.textColor = .white

            switch myRows[indexPath.row]{
            
            case .repeatRow:
                cell.detailTextLabel?.text = timeInfo.selectedWeek
            case .labelRow:
                if timeInfo.label == ""{
                    timeInfo.label = timeInfo.label
                }else{
                    cell.detailTextLabel?.text = timeInfo.label
                }
            case .soundLabel:
                cell.detailTextLabel?.text = "Radar"
            case .snoozeLabel:
                cell.detailTextLabel?.text = ""
                let mySwitch = UISwitch(frame: .zero)
                mySwitch.isOn = true
    //          mySwitch.addTarget(self, action: <#T##Selector#>, for: .valueChanged)
                cell.accessoryView = mySwitch
            }
            return cell
        
        case .delete:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.text = "Delete Alarm"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
            
        }
    }

//    MARK: - TableView Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .black
        return header
    }
    
//    MARK: - 轉場
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch mySections[indexPath.section]{
        
        case .edit:
            
            switch myRows[indexPath.row]{
            case .repeatRow:
                let repeatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepeatViewController") as! RepeatViewController
                repeatVC.delegate = self
                repeatVC.timeInfo.selectedDays = timeInfo.selectedDays
                setBackBtn()
                navigationController?.pushViewController(repeatVC, animated: true)
            case .labelRow:
                let labelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabelViewController") as! LabelViewController
                setBackBtn()
                labelVC.labelDelegate = self
                labelVC.textFieldString = timeInfo.label
                navigationController?.pushViewController(labelVC, animated: true)
            case .soundLabel:
                let soundVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SoundViewController") as! SoundViewController
                setBackBtn()
                navigationController?.pushViewController(soundVC, animated: true)
            default:
                break
            }
            
        case .delete:
                    timeInfoDelegate?.deleteIndex(index: editIndex)
                    dismiss(animated: true, completion: nil)
                }
            }
        }

extension EditViewController{
    
    enum EditSections{
        case edit, delete
    }
    
    enum EditRows{
        case repeatRow, labelRow, soundLabel, snoozeLabel
    }
}

extension EditViewController: SendWeekIndexDelegate{
    
    func weekIndex(data: Set<WeekDay>) {
        timeInfo.selectedDays = data
        infoTableView.reloadData()
    }
}

extension EditViewController: labelStringDelegate{
    
    func labelData(labelData: String) {
        if labelData == ""{
            timeInfo.label = timeInfo.label
        }else{
            timeInfo.label = labelData
        }
        infoTableView.reloadData()
    }
}
