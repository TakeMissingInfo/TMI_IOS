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
    
    var elementValue: String!
    var getStr = [String]()
    var items = [support]()
    static var getMainCategory = "DISABLE"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableMain.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.stack.layer.borderWidth = 1
        cell.stack.layer.cornerRadius = 5
        cell.stack.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.label1.text = items[indexPath.row].name
        cell.label2.text = items[indexPath.row].competentInstitution
        cell.label3.text = items[indexPath.row].detailsInfo
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCall()
    }
    
    func getCall() {
        items = [support]()
        var cnt = 0
        var subCategory = ""
        for i in 0...getStr.count-1 {
            subCategory = subCategory + "benefitType=\(getStr[i])"
            if cnt != getStr.count-1 {
                subCategory += "&"
            }
            cnt += 1
        }
        print(NetworkController.baseUrl + "api/v1/weakperson/" + SupportViewController.getMainCategory + "?" + subCategory)
        
        let task = URLSession.shared.dataTask(with: URL(string: NetworkController.baseUrl + "api/v1/weakperson/" + SupportViewController.getMainCategory + "?" + subCategory)!) { (data, response, error) in
            print("연결!")
            if let dataJson = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        if let temp = json["data"] as? NSArray {
                                for i in temp {
                                    var name : String?
                                    var competentInstitution : String?
                                    var supportForm : String?
                                    var detailsInfo : String?
                                    var detailsInfoUrl : String?
                                    
                                    if let nameStr = i as? [String:Any] {
                                        name = nameStr["name"] as! String
                                    }
                                    if let competentInstitutionStr = i as? [String:Any] {
                                        competentInstitution = competentInstitutionStr["competentInstitution"] as! String
                                    }
                                    if let detailsInfoStr = i as? [String:Any] {
                                        detailsInfo = detailsInfoStr["detailsInfo"] as! String
                                    }
                                    if let detailsInfoUrlStr = i as? [String:Any] {
                                        detailsInfoUrl = detailsInfoUrlStr["detailsInfoUrl"] as! String
                                    }
                                    if let supportFormStr = i as? [String:Any] {
                                        supportForm = supportFormStr["supportForm"] as! String
                                    }
                                    self.items.append(support(name: name, competentInstitution: competentInstitution, supportForm: supportForm, detailsInfo: detailsInfo, detailsInfoUrl: detailsInfoUrl))
                                
                            }
                        }
                    }
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료")
                
            }
            DispatchQueue.main.async {
                self.TableMain.reloadData()
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(getStr.count)
        TableMain.delegate = self
        TableMain.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "detail" == id {
            if let controller = segue.destination as? WebViewController {
                if let indexPath = TableMain.indexPathForSelectedRow {
                    let row = items[indexPath.row]
                    controller.receivedUrl = row.detailsInfoUrl
                }
            }
        }
    }
}

struct support {
    var name: String!
    var competentInstitution: String!
    var supportForm: String!
    var detailsInfo: String!
    var detailsInfoUrl: String!
}
