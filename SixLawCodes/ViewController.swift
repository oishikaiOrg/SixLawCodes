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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sixCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath)
        cell.textLabel!.text = sixCodes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // cellがタップされたときに呼ばれる処理
        print(indexPath.row) // 引数のidexpathを数値として受け取る
        let setLawNumber = lawNumber[indexPath.row]
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print("https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)")
        // urlにlawNumberを埋め込んで,そのままだと扱えないので .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)! でエンコード
        
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!

        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            let xml = XML.parse(data!)
            
            let text = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter"]
            
            let chapterNum = text.all?.count ?? 0
            DispatchQueue.main.async { // メインスレッドで行うブロック
                let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.chapterNum = chapterNum
                nextVC.setLawNumber = self.lawNumber[indexPath.row]
            }
            //let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
//            nextVC.chapterNum = chapterNum
            print("e")
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 

}

