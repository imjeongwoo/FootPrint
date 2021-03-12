//
//  NewbalanceDetailViewController.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/22.
//

import UIKit
import SafariServices

class NewbalanceDetailViewController: UIViewController {

    @IBOutlet var newbalanceDetailImage: UIImageView!
    @IBOutlet var newbalanceDetailBrand: UILabel!
    @IBOutlet var newbalanceDetailName: UILabel!
    @IBOutlet var newbalanceDetailPrice: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet weak var moveToSearchingButton: UIButton!
    
    let heart: UIImage = UIImage(systemName: "suit.heart")!
    let heartfill: UIImage = UIImage(systemName: "suit.heart.fill")!
    
    var newbalanceShoes:Shoes? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        // Do any additional setup after loading the view.
        let url = URL(string: newbalanceShoes?.img ?? "")
        if let url = url, let data = try? Data(contentsOf: url) {
            newbalanceDetailImage.image = UIImage(data: data)
            newbalanceDetailImage.layer.cornerRadius = 25.0
        }
        newbalanceDetailBrand.text = newbalanceShoes?.brand
        newbalanceDetailName.text = newbalanceShoes?.name
        newbalanceDetailPrice.text = "\(newbalanceShoes!.originPrice ?? 0) 원"
        moveToSearchingButton.layer.cornerRadius = 25.0
        if newbalanceShoes?.like == false {
            self.likeButton.setImage(heart, for: .normal)
        }else {
            self.likeButton.setImage(heartfill, for: .normal)
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        if newbalanceShoes?.like == false {// 1.LikeList에 추가해준다. 2. 전체 신발 리스트에 like를 True로 바꿔준다. 3. 해당 신발 리스트의 like를 true로 바꿔준다.
            self.likeButton.setImage(heartfill, for: .normal)
            let brand = newbalanceShoes?.brand
            let discountPrice = newbalanceShoes?.discountPrice
            let img = newbalanceShoes?.img
            let like = true
            let name = newbalanceShoes?.name
            let rank = newbalanceShoes?.rank
            let originPrice = newbalanceShoes?.originPrice
            let src = newbalanceShoes?.src
            
            let shoes:Shoes = Shoes(brand: brand, discountPrice: discountPrice, img: img, like: like, name: name, originPrice: originPrice, rank: rank, src: src)
            shoesLikeList.append(shoes)
            if let data = try? PropertyListEncoder().encode(shoesLikeList) {
                defaults.set(data, forKey: "ShoesLikeList")
            }
            var count:Int = 0
            for shoesGet in shoesGetDataList {
                if shoesGet.name == newbalanceShoes?.name {
                    shoesGetDataList[count].like = true
                }
                count += 1
            }
            var count2:Int = 0
            for newbalanceCollection in newbalanceCollectionViewList {
                if newbalanceCollection.name == newbalanceShoes?.name {
                    newbalanceCollectionViewList[count2].like = true
                }
                count2 += 1
            }
            newbalanceShoes?.like = true
        }else {// 1.LikeList에서 해당 제품을 지운다. 2. 전체 신발 리스트에서 like를 false로 바꿔준다. 3.해당 신발 리스트의 like를 false로 바꿔준다.
            self.likeButton.setImage(heart, for: .normal)
            var count:Int = 0
            for shoes in shoesLikeList {
                if shoes.name == newbalanceShoes?.name {
                    shoesLikeList.remove(at: count)
                    if let data = try? PropertyListEncoder().encode(shoesLikeList) {
                        defaults.set(data, forKey: "ShoesLikeList")
                    }
                }
                count += 1
            }
            var count2:Int = 0
            for shoesGet in shoesGetDataList {
                if shoesGet.name == newbalanceShoes?.name {
                    shoesGetDataList[count2].like = false
                }
                count2 += 1
            }
            var count3:Int = 0
            for newbalanceCollection in newbalanceCollectionViewList {
                if newbalanceCollection.name == newbalanceShoes?.name {
                    newbalanceCollectionViewList[count3].like = false
                }
                count3 += 1
            }
            newbalanceShoes?.like = false
        }
    }
    @IBAction func moveToSearching(_ sender: Any) {
        let shoesName: String? = newbalanceDetailName.text!
        let siteURL: String = "https://msearch.shopping.naver.com/search/all?query=\(shoesName ?? "")&cat_id=&frm=NVSHATC"
        let url  = siteURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        viewOnSafari(url: url)
    }
    
    func viewOnSafari(url: String) {
        let siteURL = url
        guard let url = URL(string: siteURL) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(safariViewController, animated: true, completion: nil)
    }
}
