//
//  ArticreViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/01.
//

import UIKit
import SwiftyXMLParser

class ChapterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var chapterNum: Int = 0;
    var setLawNumber = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "chapter", for: indexPath)
        cell.textLabel!.text = "第\(indexPath.row + 1)章"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            let xml = XML.parse(data!)
            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath.row,"Article"]
            let chapterTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath.row, "ChapterTitle"]
            print(chapterTitle.element?.text ?? "")
            let articleNum = text.all?.count ?? 0
            
            DispatchQueue.main.async { // メインスレッドで行うブロック
                let storyboard = UIStoryboard(name: "Article", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "article")as! ArticleViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.title = chapterTitle.element?.text
                nextVC.articleNum = articleNum
                nextVC.setLawNumber = self.setLawNumber
            }
            
        }
        
        task.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(chapterNum)
    }


}
