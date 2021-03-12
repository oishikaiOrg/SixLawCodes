//
//  ChapterRepository.swift
//  SixLawCodes
//
//  Created by kai on 2021/03/02.
//

import Foundation

class ChapterRepository {

    static func fetchChapter(row: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let lawNumber = ["昭和二十一年憲法","明治四十年法律第四十五号", "明治二十九年法律第八十九号", "明治三十二年法律第四十八号", "昭和二十三年法律第百三十一号", "昭和二十三年法律第百三十一号"]
        let setLawNumber = lawNumber[row]
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        print("https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)")
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        task.resume()

    }
}
