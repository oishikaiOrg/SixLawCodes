//
//  ViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/01/25.
//

import UIKit
import SwiftyXMLParser
import Reachability
import SVProgressHUD


class LawViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sixCodes = ["憲法", "刑法", "民法", "商法", "刑事訴訟法", "民事訴訟法"]
    let lawNumber = ["昭和二十一年憲法","明治四十年法律第四十五号", "明治二十九年法律第八十九号", "明治三十二年法律第四十八号", "昭和二十三年法律第百三十一号", "昭和二十三年法律第百三十一号"]
    
    var partTitleFlag = false
    var partTitles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "六法全書 Viwer"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sixCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath)
        cell.textLabel!.text = sixCodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // cellがタップされたときに呼ばれる処理
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            let alert: UIAlertController = UIAlertController(title: "インターネットに接続してください", message: "現在オフラインです。接続を確認してください", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
//                    print("OK")
                })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            return
        }
        SVProgressHUD.show()

        ChapterRepository.fetchChapter(row: indexPath.row) { (data: Data?, response: URLResponse?, error: Error?) in
            let xml = XML.parse(data!)
            if xml.error != nil {
                DispatchQueue.main.async { // メインスレッドで行うブロック
                    SVProgressHUD.dismiss()
                    let alert: UIAlertController = UIAlertController(title: "データの取得に失敗しました。", message: "時間を置いて再度試して下さい。", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.partTitles = []
            let chapterNum = self.countChapter(data: data, row: indexPath.row)
            let titles = self.getChapterTitle(data: data, row: indexPath.row, Chap: chapterNum)
            let lawTitle = self.sixCodes[indexPath.row]
            DispatchQueue.main.async { // メインスレッドで行うブロック
                SVProgressHUD.dismiss()
                let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.chapterNum = chapterNum
                nextVC.chapterTitles = titles
                nextVC.setLawNumber = self.lawNumber[indexPath.row]
                nextVC.partTitle = self.partTitleFlag
                nextVC.partTitles = self.partTitles
                nextVC.title = lawTitle
            }
        }
    }
 
    func countChapter(data: Data?,row : Int) -> Int{
        let xml = XML.parse(data!)
        if row == 0 {
            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter"]
            let chapterNum = text.all?.count ?? 0
            return chapterNum
        }else if row == 1 {
            let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter"]
            let text2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter"]

            let i = text1.all?.count ?? 0
            let j = text2.all?.count ?? 0
            let chapterNum = i + j
            return chapterNum
        }else if row == 2 {
            let part = 5
            var total = 0
            for i in 0...(part - 1){
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter"]
                let chap = text1.all?.count ?? 0
                total += chap
            }
            return total
        }else if row == 3 {
            let part = 3
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
    
    func getChapterTitle(data: Data?, row : Int, Chap : Int) -> [String]{
        let xml = XML.parse(data!)
        var titles: [String] = []
        if row == 0 {
            self.partTitleFlag = false
            for i in 0...(Chap - 1){
                let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", i, "ChapterTitle"]
                titles.append(text.element?.text ?? "")
            }
        }else if row == 1 {
            self.partTitleFlag = true
            let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter"]
            let text2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter"]

            let a = text1.all?.count ?? 0
            let b = text2.all?.count ?? 0
            
            for i in 0...(a - 1) {
                let part = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 0, "PartTitle"]
                let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 0, "Chapter", i, "ChapterTitle"]
                titles.append(text.element?.text ?? "")
                self.partTitles.append(part.element?.text ?? "")
            }
            
            for i in 0...(b - 1) {
                let part = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 1, "PartTitle"]
                let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision","Part", 1, "Chapter", i, "ChapterTitle"]
                titles.append(text.element?.text ?? "")
                self.partTitles.append(part.element?.text ?? "")
            }
        }else if row == 2 {
            self.partTitleFlag = true
            let part = 5
            for i in 0...(part - 1) {
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter"]
                let a = text1.all?.count ?? 0
                for j in 0...(a - 1){
                    let chapTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter", j, "ChapterTitle"]
                    let partTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "PartTitle"]
                    titles.append(chapTitle.element?.text ?? "")
                    self.partTitles.append(partTitle.element?.text ?? "")
                }
            }
        }else if row == 3 {
            self.partTitleFlag = true
            let part = 3
            for i in 0...(part - 1) {
                let text1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter"]
                let a = text1.all?.count ?? 0
                for j in 0...(a - 1){
                    let chapTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "Chapter", j, "ChapterTitle"]
                    let partTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", i, "PartTitle"]
                    titles.append(chapTitle.element?.text ?? "")
                    self.partTitles.append(partTitle.element?.text ?? "")
                }
            }

        }
        return titles
    }
}

