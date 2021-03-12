//
//  ShoesCollectionFooterReusableView.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/25.
//

import UIKit

class ShoesCollectionFooterReusableView: UICollectionReusableView {
        
    @IBOutlet var recommendLabel: UILabel!
    @IBOutlet var rightFootLength: UILabel!
    @IBOutlet var rightFootWidth: UILabel!
    @IBOutlet var leftFootLength: UILabel!
    @IBOutlet var leftFootWidth: UILabel!
    @IBOutlet var rightMeasureButton: UIButton!
    @IBOutlet var leftMeasureButton: UIButton!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var lengthLabel: UILabel!
    @IBOutlet var widthLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
}

extension UICollectionReusableView{
     func reloadHeaderCell(){
        preconditionFailure("This method must be overridden")
    }
}
