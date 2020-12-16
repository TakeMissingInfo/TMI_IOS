//
//  SupportViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class SupportViewController: UIViewController, XMLParserDelegate,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableMain: UITableView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    var receivedStr = ""
    var receivedSection = ""
    var elementValue: String!
    var item: svc!
    var items = [svc]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableMain.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.stack.layer.borderWidth = 1
        cell.stack.layer.cornerRadius = 5
        cell.stack.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.label1.text = items[indexPath.row].svcNm
        cell.label2.text = items[indexPath.row].jrsdDptAllNm
        cell.label3.text = items[indexPath.row].svcPpo
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryLabel.text = receivedStr
        print(receivedSection)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url:String="http://api.korea.go.kr/openapi/svc/list?serviceKey=ws8mgYDchhAanIfJ3kQnBdmLy5cb0ILNwiiJcA4MjvII1UQO8%2FPYVUgfrNvL7X7vzS6sOFrKjilOLKnzqmqFXQ%3D%3D&format=xml&sort=RANK&pageSize=100"
        
        let urlToSend: NSURL = NSURL(string: url)!
        
        let xmlParser = XMLParser(contentsOf: Foundation.URL(string: url)!)
                xmlParser!.delegate = self
        let success = xmlParser!.parse()
        if success {
            print("파싱 성공")
        }
        else {
            print("파싱 실패")
        }
        TableMain.delegate = self
        TableMain.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "detail" == id {
            if let controller = segue.destination as? WebViewController {
                if let indexPath = TableMain.indexPathForSelectedRow {
                    let row = items[indexPath.row]
                    controller.receivedUrl = row.svcInfoKrUrl
                    print("보낸 값 : " + row.svcInfoKrUrl)
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
           
        if elementName == "svc" {
            item = svc()
            var dic = attributeDict as Dictionary
            //print(dic)
            //item.svcId = dic["svcId"]
        }
       }
       
       // 현재 테그에 담겨있는 문자열 전달
       func parser(_ parser: XMLParser, foundCharacters string: String) {
           
           
        if elementValue == nil {
            elementValue = string
        }
        else {
            elementValue = "\(elementValue!)\(string)"
        }
       }
       
       // XML 파서가 종료 테그를 만나면 호출됨
       func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
           
           if elementName == "svc"{
            items.append(item)
           }
           else if elementName == "svcNm" {
            item.svcNm = elementValue
           }
           else if elementName == "svcPpo" {
            item.svcPpo = elementValue
           }
           else if elementName == "svcId" {
            item.svcId = elementValue
           }
           else if elementName == "jrsdDptAllNm" {
            item.jrsdDptAllNm = elementValue
           }
           else if elementName == "svcInfoUrl" {
            item.svcInfoKrUrl = elementValue
           }
           else if elementName == "sportFr" {
            item.sportFr = elementValue
           }
        elementValue = nil
       }
    
}

class svc {
    var svcId : String!
    var svcNm : String!
    var svcPpo : String!
    var jrsdDptAllNm : String!
    var svcInfoKrUrl : String!
    var sportFr : String!
}
