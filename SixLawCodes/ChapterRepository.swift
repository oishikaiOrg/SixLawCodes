//
//  ChapterRepository.swift
//  SixLawCodes
//
//  Created by kai on 2021/03/02.
//

import Foundation

class ChapterRepository {

    static func fetchChapter(row: Int) {
        let lawNumber = ["昭和二十一年憲法","明治四十年法律第四十五号", "明治二十九年法律第八十九号", "明治三十二年法律第四十八号", "昭和二十三年法律第百三十一号", "昭和二十三年法律第百三十一号"]
        let setLawNumber = lawNumber[row]
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
//            self.partTitles = []
//            let chapterNum = self.countChapter(data: data, indexPath: indexPath.row)
//            let titles = self.getChapterTitle(data: data, indexPath: indexPath.row, Chap: chapterNum)
//            DispatchQueue.main.async { // メインスレッドで行うブロック
//                let storyboard = UIStoryboard(name: "Chapter", bundle: nil)
//                let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
//                self.navigationController?.pushViewController(nextVC, animated: true)
//                nextVC.chapterNum = chapterNum
//                nextVC.chapterTitles = titles
//                nextVC.setLawNumber = self.lawNumber[indexPath.row]
//                nextVC.partTitle = self.partTitleFlag
//                nextVC.partTitles = self.partTitles
//            }
//            //let nextVC = storyboard.instantiateViewController(identifier: "chapter")as! ChapterViewController
////            nextVC.chapterNum = chapterNum
            print("hi")
        }
        task.resume()
    }
}
