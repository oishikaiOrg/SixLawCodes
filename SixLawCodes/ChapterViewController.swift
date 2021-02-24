//
//  ArticreViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/01.
//

import UIKit
import SwiftyXMLParser

class ChapterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var chapterNum: Int = 0;
    var setLawNumber = ""
    var titleSeq: [String] = []
    var chapterTitleSeq: [String] = []
    var partTitle = false
    var partTitleSeq: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChapterListTableViewCell.cellIdentifier, for: indexPath) as! ChapterListTableViewCell
        cell.chapterTitle.text = chapterTitleSeq[indexPath.row]
        if self.partTitle == true{
            cell.partTitle.text = partTitleSeq[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            let xml = XML.parse(data!)
//            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath.row,"Article"]
//            let chapterTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath.row, "ChapterTitle"]
            let chapterTitle = self.getChapterTitle(data: data, indexPath: indexPath.row)
            let articleNum = self.countArticle(data: data, indexPath: indexPath.row)
            
            self.titleSeq = []
            self.titleSeq = self.getTitleSeq(data: data, articleNum: articleNum, indexPath: indexPath.row)
//            for i in 0...(articleNum - 1){
//                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath.row ,"Article" ,i, "ArticleTitle"]
//                self.titleSeq.append(text1.element?.text ?? "")
//            }
            DispatchQueue.main.async { // メインスレッドで行うブロック
                let storyboard = UIStoryboard(name: "Article", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "article")as! ArticleViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.title = chapterTitle
                nextVC.articleNum = articleNum
                nextVC.setLawNumber = self.setLawNumber
                nextVC.chapterNum = indexPath.row
                nextVC.articleCount = self.titleSeq
            }
            
        }
        
        task.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: ChapterListTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ChapterListTableViewCell.cellIdentifier)
    }
    
    func countArticle (data: Data?, indexPath : Int) -> Int{
        let xml = XML.parse(data!)
        if self.setLawNumber == "昭和二十一年憲法" {
            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath, "Article"]
            let articleNum = text.all?.count ?? 0
            return articleNum
        }else if self.setLawNumber == "明治四十年法律第四十五号" {
            if indexPath <= 12{
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter", indexPath, "Article"]
                let articleNum = text1.all?.count ?? 0
                return articleNum
            }else{
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter", indexPath, "Article"]
                let articleNum = text1.all?.count ?? 0
                return articleNum
            }
        }
        return 0
    }
    
    func getTitleSeq(data:Data?, articleNum: Int, indexPath : Int) -> [String]{
        let xml = XML.parse(data!)
        var Seq :[String] = []
        if self.setLawNumber == "昭和二十一年憲法" {
            for i in 0...(articleNum - 1){
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath,"Article" ,i, "ArticleTitle"]
                Seq.append(text1.element?.text ?? "")
            }
            return Seq
        }else if self.setLawNumber == "明治四十年法律第四十五号" {
            if indexPath <= 12{
                for i in 0...(articleNum - 1){
                    let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter", indexPath,"Article" ,i, "ArticleTitle"]
                    Seq.append(text1.element?.text ?? "")
                }
            }else{
                let truePath = indexPath - 13
                for i in 0...(articleNum - 1){
                    let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter", truePath,"Article" ,i, "ArticleTitle"]
                    Seq.append(text1.element?.text ?? "")
                }
            }
        }
        return Seq
    }
    
    func getChapterTitle (data: Data?, indexPath : Int) -> String?{
        let xml = XML.parse(data!)
        if self.setLawNumber == "昭和二十一年憲法" {
            let titleA = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", indexPath, "ChapterTitle"]
            let chapterTitle = titleA.element?.text
            return chapterTitle
        }else if self.setLawNumber == "明治四十年法律第四十五号"{
            if indexPath <= 12{
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" ,indexPath, "ChapterTitle"]
                let chapterTitle = text1.element?.text
                return chapterTitle
            }else {
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter" ,indexPath, "ChapterTitle"]
                let chapterTitle = text1.element?.text
                return chapterTitle
            }
        }
        return nil
    }
}
