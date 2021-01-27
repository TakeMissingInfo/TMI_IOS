//
//  ListViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/08.
//

import UIKit

class CommonClassificationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var selectStr: UILabel!
    var collectionView: UICollectionView?
    var setIndex = -1
    var selectedConut = 0
    @IBOutlet var nextButton: CustomButton!
    var isSelected = [false,false,false,false,false,false,false,false]
    var categories = ["취업, 직장", "금융, 세금 법률", "생활, 병역", "건강, 의료, 사망", "결혼, 육아, 교육", "환경, 재난", "주택, 부동산", "자동차, 교통"]
    var images = ["employment", "dollar", "military", "pulse", "baby", "environment", "house", "car"]
    var clickStr = ""
    var collectionWidth : CGFloat? = nil
    
    @IBOutlet weak var CollectionViewMain: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionWidth = collectionView.bounds.width
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setIndex = indexPath.row
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonClassificationCell", for: indexPath) as! CommonClassificationCell
    
        cell.label.text = categories[indexPath.row]
        cell.image.image = resize(getImage: UIImage(named: images[indexPath.row])!)
        
        cell.stack.layer.borderWidth = 1
        cell.stack.layer.cornerRadius = 5
        cell.stack.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let selectedCell: CommonClassificationCell = collectionView.cellForItem(at: indexPath) as! CommonClassificationCell
        
        if !isSelected[indexPath.row] {
            isSelected[indexPath.row] = true
            selectedConut += 1
            selectedCell.label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else {
            isSelected[indexPath.row] = false
            selectedConut -= 1
            selectedCell.label.textColor = UIColor.black
        }
        
        if selectedConut == 0 {
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.nextButton.setTitleColor(.lightGray, for: .normal)
        }
        else {
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            self.nextButton.setTitleColor(.white, for: .normal)
        }
        
        setStr()
    }
    
    func setStr() {
        clickStr = ""
        var cnt = 0
        for i in 0...isSelected.count-1 {
            if isSelected[i] {
                clickStr = clickStr + categories[i] + " / "
            }
            else {
                cnt += 1
            }
        }
        if cnt == isSelected.count {
            self.selectStr.text = "분류를 선택하세요"
            self.selectStr.textColor = UIColor.lightGray
        }
        else {
            selectStr.text = clickStr
            selectStr.textColor = UIColor.darkGray
        }
    }
    
    
    func resize(getImage:UIImage) -> UIImage {
        
        let wif = CollectionViewMain.layer.borderWidth
        var new_image : UIImage!
        let size = CGSize(width:  collectionWidth!*0.15, height:collectionWidth!*0.15 )

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)

        getImage.draw(in: rect)

        new_image = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return new_image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "next" == id {
            if let controller = segue.destination as? SupportViewController {
                guard let selectedIndexPath = CollectionViewMain.indexPathsForSelectedItems?.first else{
                    assertionFailure("The first element is nil.")
                    return
                }
                for i in 0...isSelected.count - 1 {
                    if(isSelected[i]) {
                        var temp = ""
                        switch categories[i] {
                        case "취업, 직장":
                            temp = "EMPLOYMENT"
                        case "금융, 세금 법률":
                            temp = "FINANCE"
                        case "건강, 의료, 사망":
                            temp = "MEDICAL_CARE"
                        case "생활, 병역":
                            temp = "LIFE"
                        case "결혼, 육아, 교육":
                            temp = "MARRIAGE_PARENTING"
                        case "환경, 재난":
                            temp = "ENVIRONMENTAL_DISASTER"
                        case "주택, 부동산":
                            temp = "HOUSING"
                        case "자동차, 교통":
                            temp = "MOTOR_TRAFFIC"
                        default:
                            temp = "nil"
                        }
                        controller.getStr.append(temp)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectStr.text = "분류를 선택하세요"
        self.selectStr.textColor = UIColor.lightGray
        self.nextButton.isUserInteractionEnabled = false
        self.nextButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.nextButton.setTitleColor(.lightGray, for: .normal)
        CollectionViewMain.dataSource = self
        CollectionViewMain.delegate = self
    }
    
}

extension CommonClassificationViewController: UICollectionViewDelegateFlowLayout {

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let collectionWidth = collectionView.bounds.width
    return CGSize(width: collectionWidth/2, height: collectionWidth/2)

}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0

}
}
