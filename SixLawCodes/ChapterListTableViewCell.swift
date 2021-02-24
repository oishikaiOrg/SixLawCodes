//
//  ChapterListTableViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/21.
//

import UIKit

class ChapterListTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var chapterTitle: UILabel!
    @IBOutlet weak var partTitle: UILabel!
    
    static let cellIdentifier = String(describing: ChapterListTableViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
