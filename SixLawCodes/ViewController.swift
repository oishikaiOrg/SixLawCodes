//
//  ViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/01/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sixCodes = ["憲法", "刑法", "民法", "商法", "刑事訴訟法", "民事訴訟法"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sixCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath)
        cell.textLabel!.text = sixCodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // cellがタップされたときに呼ばれる処理
        let storyboard = UIStoryboard(name: "Article", bundle: nil)  //storyboardクラスのインスタンスとしてArticle.storyboardを指定
        let vc = storyboard.instantiateViewController(identifier: "article")  //Article.storyboard中の"article"をIDとして持つviewを指定
        self.navigationController?.pushViewController(vc, animated: true)
        //    let storyboard: UIStoryboard = self.storyboard!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



    
    

}

