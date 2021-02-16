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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentence.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "paragraph", for: indexPath)
        cell.textLabel!.text = sentence[indexPath.row]
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sentence[0])
    }
    
    

}
