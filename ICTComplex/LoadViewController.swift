//
//  WebViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/09.
//

import UIKit

class LoadViewController: UIViewController, UIWebViewDelegate {

    var receivedUrl = ""
    @IBOutlet var myWebView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("받은 값 : " + receivedUrl)
    }
    
    func loadWebPage(_ url: String) {
           
           // url에 공백이나 한글이 포함되었있을 경우, 에러가 발생하니 url을 인코딩
           let escapedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
           
           let myUrl = URL(string: escapedString!)
           let myRequest = URLRequest(url: myUrl!)
           myWebView.loadRequest(myRequest)
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           myWebView.delegate = self
           loadWebPage(receivedUrl) // 앱 실행 시 초기 홈페이지를 불러옴
       }
       
       //"http://" 문자열이 없을 경우 자동으로 삽입
       func checkUrl(_ url: String) -> String {
           var strUrl = url
           let flag = strUrl.hasPrefix("http://")
           if !flag {
               strUrl = "http://" + strUrl
           }
           return strUrl
       }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
