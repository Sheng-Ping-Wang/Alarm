//
//  TableViewCell3.swift
//  Alarm
//
//  Created by Wang Sheng Ping on 2021/1/8.
//

import UIKit

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
