//
//  ViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/01/25.
//

import UIKit
import SwiftyXMLParser
/*
public struct Chapter: XMLIndexerDeserializable {
    var ChapterTitle : String = ""
    
    init(ChapterTitle: String){
        self.ChapterTitle = ChapterTitle
    }
    public static func deserialize(_ node: XMLIndexer) throws -> Chapter{
        return try Chapter (
            ChapterTitle: node["ChapterTitle"].value()
            )
    }
}
*/

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sixCodes = ["憲法", "刑法", "民法", "商法", "刑事訴訟法", "民事訴訟法"]
    let lawNumber = ["昭和二十一年憲法","明治四十年法律第四十五号", "明治二十九年法律第八十九号", "明治三十二年法律第四十八号", "昭和二十三年法律第百三十一号", "昭和二十三年法律第百三十一号"]
    
    var partTitleFlag = false
    var partTitleSeq:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sixCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath)
        cell.textLabel!.text = sixCodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // cellがタップされたときに呼ばれる処理
        let setLawNumber = lawNumber[indexPath.row]
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print("https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)")
        // urlにlawNumberを埋め込んで,そのままだと扱えないので .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! でエンコード
        
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!

        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            self.partTitleSeq = []
            let chapterNum = self.countChapter(data: data, indexPath: indexPath.row)
            let titleSeq = self.getChapterTitle(data: data, indexPath: indexPath.row, Chap: chapterNum)
            DispatchQueue.main.async { // メインスレッドで行うブロック
                let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.chapterNum = chapterNum
                nextVC.chapterTitleSeq = titleSeq
                nextVC.setLawNumber = self.lawNumber[indexPath.row]
                nextVC.partTitle = self.partTitleFlag
                nextVC.partTitleSeq = self.partTitleSeq
            }
            //let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
//            nextVC.chapterNum = chapterNum
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    func countChapter(data: Data?,indexPath : Int) -> Int{
        let xml = XML.parse(data!)
        if indexPath == 0 {
            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter"]
            let chapterNum = text.all?.count ?? 0
            return chapterNum
        }else if indexPath == 1 {
            let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter"]
            let text2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter"]

            let i = text1.all?.count ?? 0
            let j = text2.all?.count ?? 0
            let chapterNum = i + j
            return chapterNum
        }else if indexPath == 2 {
            let part = 5
            var total = 0
            for i in 0...(part - 1){
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter"]
                let chap = text1.all?.count ?? 0
                total += chap
            }
            return total
        }
        return 0
    }
    
    func getChapterTitle(data: Data?,indexPath : Int, Chap : Int) -> [String]{
        let xml = XML.parse(data!)
        var titleSeq: [String] = []
        if indexPath == 0 {
            for i in 0...(Chap - 1){
                let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", i, "ChapterTitle"]
                titleSeq.append(text.element?.text ?? "")
            }
        }else if indexPath == 1 {
            self.partTitleFlag = true
            let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter"]
            let text2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter"]

            let a = text1.all?.count ?? 0
            let b = text2.all?.count ?? 0
            
            for i in 0...(a - 1) {
                let part = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 0, "PartTitle"]
                let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 0, "Chapter", i, "ChapterTitle"]
                titleSeq.append(text.element?.text ?? "")
                self.partTitleSeq.append(part.element?.text ?? "")
            }
            
            for i in 0...(b - 1) {
                let part = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 1, "PartTitle"]
                let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 1, "Chapter", i, "ChapterTitle"]
                titleSeq.append(text.element?.text ?? "")
                self.partTitleSeq.append(part.element?.text ?? "")
            }
        }else if indexPath == 2 {
            self.partTitleFlag = true
            let part = 5
            for i in 0...(part - 1) {
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter"]
                let a = text1.all?.count ?? 0
                for j in 0...(a - 1){
                    let chapTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter", j, "ChapterTitle"]
                    let partTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "PartTitle"]
                    titleSeq.append(chapTitle.element?.text ?? "")
                    self.partTitleSeq.append(partTitle.element?.text ?? "")
                }
            }
        }
        return titleSeq
    }
}

