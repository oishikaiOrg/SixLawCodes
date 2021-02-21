//
//  ArticleViewController.swift
//  SixLawCodes
//
//  Created by kai on 2021/02/14.
//

import UIKit
import SwiftyXMLParser

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var chapterNum = 0
    var articleNum = 0
    var setLawNumber = ""
    var articleCount: [String] = []
    var sentence: [String] = []
    var seq = 0
    var itemCount = 0;
    var ParagraphSentenceCount = 0;
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath)
        cell.textLabel!.text = articleCount[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            let xml = XML.parse(data!)
            let sequence = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" ,indexPath.row, "Paragraph"]
            self.seq = self.getNumberOfSentence(data: data, indexPath: indexPath.row)
            print(self.seq)
            self.sentence = self.getSentence(data: data, indexPath: indexPath.row)
            
//            for i in 0...(self.seq - 1){
//                let sentenseSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , indexPath.row, "Paragraph", i, "ParagraphSentence", "Sentence"]
////                let itemChecker1 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", 4,"Article" , 72, "Paragraph", i, "ParagraphSentence", "Sentence"]
////                let itemChecker2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", 0,"Article" , 6, "Paragraph", i, "ParagraphSentence", "Sentence"]
//                print(sentenseSeq.element?.text)
//                if(sentenseSeq.element?.text == nil){
//                    let sentenseSequExeption = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , indexPath.row, "Paragraph", i]
//                    let count = sentenseSequExeption.element?.childElements[1].childElements.count ?? 0
//                    for j in 0...(count - 1){
//                        print(sentenseSequExeption.element?.childElements[1].childElements[j].text)
//                        self.sentence.append(sentenseSequExeption.element?.childElements[1].childElements[j].text ?? "")
//                        print(self.sentence[j])
//                    }
////                    sentenseSequ.element?.childElements[1].childElements[0].text
//                }else{
//                    self.sentence.append(sentenseSeq.element?.text ?? "")
//                    print(sentenseSeq.element?.childElements.count)
//                    if(sentenseSeq.element?.childElements.count ?? 0 >= 4){
//                        print("hi")
//                    }
//                }
//
//            }
            
            DispatchQueue.main.async { // メインスレッドで行うブロック
                let storyboard = UIStoryboard(name: "Paragraph", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "paragraph")as! ParagraphViewController
                self.navigationController?.pushViewController(nextVC, animated: true)
                nextVC.title = self.articleCount[indexPath.row]
                nextVC.sentence = self.sentence
                nextVC.paragraphNum = self.seq
            }
        }
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    func getNumberOfSentence(data: Data?, indexPath: Int) -> Int{
        let xml = XML.parse(data!)
        if self.setLawNumber == "昭和二十一年憲法"{
            let sequence = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" ,indexPath, "Paragraph"]
            return sequence.all?.count ?? 0
        }else if self.setLawNumber == "明治四十年法律第四十五号"{
            if indexPath <= 12{
                let sequence = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph","Item"]
                let sequence2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph"]
                self.itemCount = sequence.all?.count ?? 0
                self.ParagraphSentenceCount = sequence2.all?.count ?? 0
                return (sequence.all?.count ?? 0) + (sequence2.all?.count ?? 0)
            }else{
                let sequence = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph", "Item"]
                let sequence2 = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 1, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph"]
                self.itemCount = sequence.all?.count ?? 0
                self.ParagraphSentenceCount = sequence2.all?.count ?? 0
                return (sequence.all?.count ?? 0) + (sequence2.all?.count ?? 0)
            }
        }
        return 0
    }
    
    func getSentence(data: Data?, indexPath: Int) ->[String]{
        let xml = XML.parse(data!)
        var sentence : [String] = []
        if self.setLawNumber == "昭和二十一年憲法"{
            for i in 0...(self.seq - 1){
                let sentenseSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , indexPath, "Paragraph", i, "ParagraphSentence", "Sentence"]
//                print(sentenseSeq.element?.text)
                if(sentenseSeq.element?.text == nil){
                    let sentenseSequExeption = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , indexPath, "Paragraph", i]
                    let count = sentenseSequExeption.element?.childElements[1].childElements.count ?? 0
                    for j in 0...(count - 1) {
                        print(sentenseSequExeption.element?.childElements[1].childElements[j].text)
                        sentence.append(sentenseSequExeption.element?.childElements[1].childElements[j].text ?? "")
                    }
                    return sentence
                }else{
                    
                    sentence.append(sentenseSeq.element?.text ?? "")
                    return sentence
                    if(sentenseSeq.element?.childElements.count ?? 0 >= 4){
                        print("hi")
                    }
                }
            }
        }else if self.setLawNumber == "明治四十年法律第四十五号"{
            if indexPath <= 12 {
                if itemCount == 0 {
                    for i in 0...(self.ParagraphSentenceCount - 1) {
                        let sequenceSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph", i, "ParagraphSentence", "Sentence"]
                        sentence.append(sequenceSeq.element?.text ?? "")
                    }
                }else{
                    for i in 0...(self.ParagraphSentenceCount - 1) {
                        let sequenceSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph", i, "ParagraphSentence", "Sentence"]
                        sentence.append(sequenceSeq.element?.text ?? "")
                    }
                    
                    for i in 0...(self.itemCount - 1) {
                        let sequenceSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph", 0, "Item", i, "ItemSentence", "Sentence"]
                        let sequenceTitle = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Part", 0, "Chapter" , self.chapterNum, "Article" ,indexPath, "Paragraph", 0, "Item", i, "ItemTitle"]
                        sentence.append((sequenceTitle.element?.text ?? "") + " :\n" + (sequenceSeq.element?.text ?? ""))
                    }
                }
            }
        }
        return sentence
    }

}
