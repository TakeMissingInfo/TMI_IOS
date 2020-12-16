//
//  CustomView.swift
//  ICTComplex
//
//  Created by 이명직 on 2020/12/07.
//

import UIKit

class CustomView: UIView {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 10
        
    }
}
