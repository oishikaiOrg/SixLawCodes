//
//  ArticreViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/01.
//

import UIKit

class ArticreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var examArticle = ["一条", "二条", "三条"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath)
        cell.textLabel!.text = examArticle[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
