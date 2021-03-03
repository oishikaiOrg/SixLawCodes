//
//  SentenceListTableViewCell.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/16.
//

import UIKit

class SentenceListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    static let cellIdentifier = String(describing: SentenceListTableViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
