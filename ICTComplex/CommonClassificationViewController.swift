//
//  ListViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/08.
//

import UIKit

class CommonClassificationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    var setIndex = -1
    var categories = ["취업, 직장", "금융, 세금 법률", "생활, 병역", "건강, 의료, 사망", "결혼, 육아, 교육", "환경, 재난", "주택, 부동산", "자동차, 교통"]
    var images = ["accessible", "elderly", "money", "house"]
    var collectionWidth : CGFloat? = nil
    
    @IBOutlet weak var CollectionViewMain: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionWidth = collectionView.bounds.width
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonClassificationCell", for: indexPath) as! CommonClassificationCell
    
        cell.label.text = categories[indexPath.row]
        cell.image.image = resize(getImage: UIImage(named: images[indexPath.row%4])!)
        
        cell.stack.layer.borderWidth = 1
        cell.stack.layer.cornerRadius = 5
        cell.stack.layer.borderColor = UIColor.lightGray.cgColor
        return cell
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
        if let id = segue.identifier, "List" == id {
            if let controller = segue.destination as? SupportViewController {
                guard let selectedIndexPath = CollectionViewMain.indexPathsForSelectedItems?.first else{
                    assertionFailure("The first element is nil.")
                    return
                }
                controller.receivedStr = categories[selectedIndexPath.row]
               
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        CollectionViewMain.collectionViewLayout = layout
        CollectionViewMain.dataSource = self
        CollectionViewMain.delegate = self
        // Do any additional setup after loading the view.
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
