//
//  detailViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2021/02/01.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet var number: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var operation: UILabel!
    @IBOutlet var time: UILabel!
    var addressStr: String?
    var numberStr: String?
    var dateStr: String?
    var timeStr: String?
    var getName: String?
    var getX: Double?
    var getY: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let a = addressStr {
            address.text = a
        }
        if let n = numberStr {
            number.text = n
        }
        if let d = dateStr {
            operation.text = d
        }
        if let t = timeStr {
            time.text = t
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func findRoad(_ sender: Any) {
        var url = "https://map.kakao.com/link/to/" + getName! + ",\(getX!),\(getY!)"
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "LoadViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        let temp = popUp as? LoadViewController
        
        temp?.receivedUrl = url
        self.present(popUp, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
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
