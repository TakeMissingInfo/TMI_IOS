//
//  ListViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/08.
//

import UIKit

class areaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
   
    var categories = ["서울", "인천", "충청도", "전라도", "경상도", "제주도", "제주도", "제주도"]
    var collectionWidth : CGFloat? = nil
    
    @IBOutlet weak var CollectionViewMain: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionWidth = collectionView.bounds.width
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "areaCell", for: indexPath) as! areaCell
    
        cell.label.text = categories[indexPath.row]
        
        cell.stack.layer.borderWidth = 1
        cell.stack.layer.cornerRadius = 5
        cell.stack.layer.borderColor = UIColor.lightGray.cgColor
        return cell
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
    @IBAction func selectArea(_ sender: Any) {
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

extension areaViewController: UICollectionViewDelegateFlowLayout {

func areaViewController(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

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
