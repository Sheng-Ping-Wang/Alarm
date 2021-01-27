//
//  LabelViewController.swift
//  Alarm
//
//  Created by Wang Sheng Ping on 2021/1/12.
//

import UIKit

protocol labelStringDelegate {
    func labelData(labelData: String)
}

class LabelViewController: UIViewController {

//    MARK: - Properties
    
    @IBOutlet weak var labelTextField: UITextField!
    var labelDelegate: labelStringDelegate?
    var textFieldString: String?
    
//    MARK: - Pass information to last page
    
    override func viewWillDisappear(_ animated: Bool) {
        if labelTextField.text == ""{
            labelDelegate?.labelData(labelData: "Alarm")
        }else{
        labelDelegate?.labelData(labelData: labelTextField.text ?? "Alarm")
        }
    }

//    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Label"
        if textFieldString == "" {
            labelTextField.text = "Alarm"
        }else{
            labelTextField.text = textFieldString
        }
        labelTextField.clearButtonMode = .whileEditing
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
