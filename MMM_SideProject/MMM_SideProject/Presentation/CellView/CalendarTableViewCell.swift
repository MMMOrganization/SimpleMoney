//
//  CalendarTableViewCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/4/25.
//

import UIKit

final class CalendarTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    deinit {
        print("CalendarTableViewCell - 메모리 해제")
    }
}
