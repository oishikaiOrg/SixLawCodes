//
//  ParagraphRepository.swift
//  SixLawCodes
//
//  Created by kai on 2021/03/04.
//

import Foundation

class ParagraphRepository {
    static func fetchParagraph(row: Int, setLawNumber: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://elaws.e-gov.go.jp/api/1/lawdata/\(setLawNumber)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }

}
