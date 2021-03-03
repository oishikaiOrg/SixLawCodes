//
//  ParagraphViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/14.
//

import UIKit

class ParagraphViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var sentence: [String] = []
    var paragraphNum = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentence.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SentenceListTableViewCell.cellIdentifier, for: indexPath) as! SentenceListTableViewCell
//        cell.textLabel!.text = sentence[indexPath.row]
        cell.label.text = sentence[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: SentenceListTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SentenceListTableViewCell.cellIdentifier)
    }
    
    

}
