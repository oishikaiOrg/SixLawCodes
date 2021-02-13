//
//  ArticreViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/01.
//

import UIKit

class ChapterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var examArticle = ["一条", "二条", "三条"]
    
    var chapterNum: Int = 0;
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "chapter", for: indexPath)
        cell.textLabel!.text = "第\(indexPath.row + 1)章"
        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(chapterNum)
    }


}
