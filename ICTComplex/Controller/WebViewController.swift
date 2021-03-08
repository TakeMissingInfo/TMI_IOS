//
//  WebViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/09.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var myWebView: UIWebView!
    var receivedUrl = ""
    
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
        loadWebPage(receivedUrl)
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
