//
//  ErrorAlert.swift
//  SixLawCodes
//
//  Created by kai on 2021/03/12.
//

import UIKit

class ErrorAlert {
    static func internetError() -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: "インターネットに接続してください", message: "現在オフラインです。接続を確認してください", preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
            })
        alert.addAction(defaultAction)
        return alert
    }
    
    static func parseError() -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: "データの取得に失敗しました。", message: "時間を置いて再度試して下さい。", preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(defaultAction)
        return alert
    }
}
