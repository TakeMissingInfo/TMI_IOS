//
//  CustomButton.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/07.
//

import UIKit
import Foundation

class CustomButton : UIButton{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        let colorLiteral = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = colorLiteral.cgColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 17)
        
    }
     
}
