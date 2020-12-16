//
//  ListViewController.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/08.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories = ["장애인", "노인", "저소득층", "소년소녀가정"]
    var images = ["accessible", "elderly", "money", "house"]
    var collectionWidth : CGFloat? = nil
    
    @IBOutlet weak var CollectionViewMain: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionWidth = collectionView.bounds.width
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.label.text = categories[indexPath.row]
        cell.image.image = resize(getImage: UIImage(named: images[indexPath.row])!)
        
        cell.stack.layer.borderWidth = 1
        cell.stack.layer.cornerRadius = 5
        cell.stack.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard.init(name: "SelectStoryboard", bundle: nil)
            
            let popUp = storyboard.instantiateViewController(identifier: "SelectStoryboard")
            popUp.modalPresentationStyle = .overCurrentContext
            popUp.modalTransitionStyle = .crossDissolve
            
            self.present(popUp, animated: true, completion: nil)
        }
    }
    @IBAction func selectArea(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "area", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "area")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        self.present(popUp, animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
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

extension ListViewController: UICollectionViewDelegateFlowLayout {

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
