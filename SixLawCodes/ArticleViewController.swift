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
    var part = 0
    
    private var seq = 0
    private var itemCount = 0;
    private var ParagraphSentenceCount = 0;
    
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
            self.seq = self.getNumberOfSentence(data: data, row: indexPath.row)
            self.sentence = self.getSentence(data: data, row: indexPath.row)
            
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
    

    func getNumberOfSentence(data: Data?, row: Int) -> Int{
        let xml = XML.parse(data!)
        self.itemCount = 0
        if self.setLawNumber == "昭和二十一年憲法"{
            let sequence = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" ,row, "Paragraph"]
            return sequence.all?.count ?? 0
        }else if self.setLawNumber == "明治四十年法律第四十五号"{
            let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph
            let ParagraphCnt = Paragraph.all?.count ?? 0
            var sentenceCnt = 0
            for i in 0...(ParagraphCnt - 1) {
                let Psentence = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence
                let Isentence = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].Item
                sentenceCnt += (Psentence.all?.count ?? 0) + (Isentence.all?.count ?? 0)
                self.itemCount += Isentence.all?.count ?? 0
                
            }
            return sentenceCnt
        }else if self.setLawNumber == "明治二十九年法律第八十九号"{
            var sentenceCnt = 0
            let Try = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section
            if Try.all?.count == nil {
                let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph
                let ParagraphCnt = Paragraph.all?.count ?? 0
    
                for i in 0...(ParagraphCnt - 1) {
                    let ParagraphSen = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence
                    sentenceCnt += (ParagraphSen.all?.count ?? 0)
                }
                return sentenceCnt
            }else {
                var sectionSenCnt : [Int] = []
                for i in 0...((Try.all?.count ?? 0) - 1) {
                    let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article
                    let ArtCnt = Paragraph.all?.count ?? 0
                    for j in 0...(ArtCnt - 1) {
                        var demandCell = 0
                        let article = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article[j].Paragraph
                        let ParaCnt = article.all?.count ?? 0
                        for n in 0...(ParaCnt - 1) {
                            let para = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article[j].Paragraph[n].ParagraphSentence.Sentence
                            let sentCnt = para.all?.count ?? 0
                            demandCell += sentCnt
                        }
                        let finaldemand = demandCell
                        sectionSenCnt.append(finaldemand)
                    }
                }
                return sectionSenCnt[row]
            }
        }
        return 0
    }
    
    func getSentence(data: Data?, row: Int) ->[String]{
        let xml = XML.parse(data!)
        var sentence : [String] = []
        if self.setLawNumber == "昭和二十一年憲法"{
            for i in 0...(self.seq - 1){
                let sentenseSeq = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , row, "Paragraph", i, "ParagraphSentence", "Sentence"]
//                print(sentenseSeq.element?.text)
                if(sentenseSeq.element?.text == nil){
                    let sentenseSequExeption = xml["DataRoot", "ApplData", "LawFullText", "Law", "LawBody", "MainProvision", "Chapter", self.chapterNum,"Article" , row, "Paragraph", i]
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
            if itemCount == 0 {
                let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph
                let ParagraphCnt = Paragraph.all?.count ?? 0
                for i in 0...(ParagraphCnt - 1) {
                    let sentenceGet = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence
                    let sentenceCnt = sentenceGet.all?.count ?? 0
                    for j in 0...(sentenceCnt - 1) {
                        let sentences = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence[j]
                        sentence.append(sentences.element?.text ?? "")
                    }
                }
            }else {
                let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph
                let ParagraphCnt = Paragraph.all?.count ?? 0
                for i in 0...(ParagraphCnt - 1) {
                    let sentenceGet = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence
                    let sentenceCnt = sentenceGet.all?.count ?? 0
                    for j in 0...(sentenceCnt - 1) {
                        let sentences = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence[j]
                        sentence.append(sentences.element?.text ?? "")
                    }
                    
                    for j in 0...(self.itemCount - 1) {
                        let sentences = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].Item[j].ItemSentence.Sentence
                        let sentencesTitle = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].Item[j].ItemTitle
                        sentence.append((sentencesTitle.element?.text ?? "") + " :\n" + (sentences.element?.text ?? ""))
                    }
                }
                return sentence
            }
            return sentence
        }else if self.setLawNumber == "明治二十九年法律第八十九号" {
            let Try = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section
            if Try.all?.count == nil {
                let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph
                let ParagraphCnt = Paragraph.all?.count ?? 0
                for i in 0...(ParagraphCnt - 1) {
                    let sentenceGet = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence
                    let sentenceCnt = sentenceGet.all?.count ?? 0
                    for j in 0...(sentenceCnt - 1) {
                        let textGet = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Article[row].Paragraph[i].ParagraphSentence.Sentence[j]
                        let text = textGet.element?.text ?? ""
                        sentence.append(text)
                    }
                }
                return sentence
            }else {
                var sentenceArray : [[String]] = []
                for i in 0...((Try.all?.count ?? 0) - 1) {
                    let Paragraph = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article
                    let ArtCnt = Paragraph.all?.count ?? 0
                    for j in 0...(ArtCnt - 1) {
                        var sentenceBit : [String] = []
                        let article = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article[j].Paragraph
                        let ParaCnt = article.all?.count ?? 0
                        for n in 0...(ParaCnt - 1) {
                            let sentenceGet = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article[j].Paragraph[n].ParagraphSentence.Sentence
                            let SenCnt = sentenceGet.all?.count ?? 0
                            for m in 0...(SenCnt - 1){
                                let textGet = xml.DataRoot.ApplData.LawFullText.Law.LawBody.MainProvision.Part[self.part].Chapter[self.chapterNum].Section[i].Article[j].Paragraph[n].ParagraphSentence.Sentence[m]
                                let text = textGet.element?.text ?? ""
                                sentenceBit.append(text)
                            }
                        }
                        sentenceArray.append(sentenceBit)
                    }
                }
                return sentenceArray[row]
            }
        }
        return sentence
    }
}
