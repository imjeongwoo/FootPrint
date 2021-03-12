//
//  ShoesViewController.swift
//  TeamProject
//
//  Created by 홍화형 on 2021/01/21.
//

import UIKit
import Firebase

var shoesGetDataList = [Shoes]() // 데이터에서 받은 신발 리스트들
var shoesLikeList = [Shoes]() // 좋아요 누른 신발 리스트 전역변수
var newbalanceCollectionViewList = [Shoes]()// 신발들을 shoesGedDataList로 받은 다음 거기서 nike만 꺼낸거
var nikeCollectionViewList = [Shoes]()
var footSize = FootSize(length: 0.0, width: 0.0, recommendSize: 0)
var rightFootSize = FootSize(length: 0.0, width: 0.0, recommendSize: 0)
var leftFootSize = FootSize(length: 0.0, width: 0.0, recommendSize: 0)
var left:Bool = true

class ShoesViewController: ExtensionVC {

    let width = UIScreen.main.bounds.width
    
    @IBOutlet var shoesCollectionView: UICollectionView!
    var refNike: DatabaseReference!
    var refNewbalance: DatabaseReference!
    var footerView: ShoesCollectionFooterReusableView?
    
    @IBAction func unwindVC (segue : UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoesCollectionView.contentInsetAdjustmentBehavior = .never
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource = self
        initRefresh()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        DispatchQueue.global().async {
            self.updateNike()
            self.updateNewbalance()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
            UIViewController.removeSpinner(spinner: sv)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        // 데이터 불러오기
        if let footData = defaults.data(forKey: "FootData") {
            footSize = try! PropertyListDecoder().decode(FootSize.self, from: footData)
        }
        if let leftFootData = defaults.data(forKey: "LeftFootData") {
            leftFootSize = try! PropertyListDecoder().decode(FootSize.self, from: leftFootData)
        }
        if let rightFootData = defaults.data(forKey: "RightFootData") {
            rightFootSize = try! PropertyListDecoder().decode(FootSize.self, from: rightFootData)
        }
        if let data = defaults.data(forKey: "ShoesLikeList") {
            shoesLikeList = try! PropertyListDecoder().decode([Shoes].self, from: data)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        shoesCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nikeDetailSegue" {
            let VC = segue.destination as! NikeDetailViewController
            VC.nikeShoes = sender as? Shoes
        } else if segue.identifier == "newbalanceDetailSegue" {
            let VC = segue.destination as! NewbalanceDetailViewController
            VC.newbalanceShoes = sender as? Shoes
        }
    }
    
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            shoesCollectionView.refreshControl = refresh
        } else {
            shoesCollectionView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        
        self.updateNike()
        self.updateNewbalance()
        
    }
    @IBAction func rightFootMeasureButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "toMeasure", sender: nil)
        left = false
        print("rkrkrkrkrkrk")
    }
    @IBAction func leftFootMeasureButtonTap(_ sender: Any) {
        performSegue(withIdentifier: "toMeasure", sender: nil)
        left = true
        print("lelelel")
    }
}


extension ShoesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems: Int
        
        if section == 1 || section == 2 { numberOfItems = nikeCollectionViewList.count }
        else { numberOfItems = 0 }
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoesCell", for: indexPath) as! ShoesCollectionViewCell
        
        cell.shoesImage.image = nil
        DispatchQueue.global().async {
            var refBrand: [Shoes]? {
                if indexPath.section == 1 {
                    return nikeCollectionViewList
                } else if indexPath.section == 2 {
                    return newbalanceCollectionViewList
                }
                return nil
            }
            
            
            let shoes: Shoes = refBrand![indexPath.row]
            guard let imageURL: URL = URL(string: shoes.img ?? "") else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                if let index: IndexPath = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.shoesImage.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                        cell.layer.cornerRadius = 10.0
                        cell.shoesImage.layer.cornerRadius = 25.0
                    }
                }
            }
        }
        return cell
    }
    
    func updateNike() {
        refNike = Database.database().reference().child("Nike")
        refNike.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0 {
                nikeCollectionViewList.removeAll()
                shoesGetDataList.removeAll()

                for nikes in snapshot.children.allObjects as! [DataSnapshot] {
                    let nikeObject = nikes.value as? [String: AnyObject]
                    let nikeBrand = nikeObject?["brand"]
                    let nikeDiscountPrice = nikeObject?["discountPrice"]
                    let nikeImg = nikeObject?["img"]
                    let nikeLike = nikeObject?["like"]
                    let nikeName = nikeObject?["name"]
                    let nikeOriginPrice = nikeObject?["originPrice"]
                    let nikeRank = nikeObject?["rank"]
                    let nikeSrc = nikeObject?["src"]
                    
                    var nikeGetData = Shoes(brand: nikeBrand as? String, discountPrice: nikeDiscountPrice as? Int, img: nikeImg as? String, like: nikeLike as? Bool, name: nikeName as? String, originPrice: nikeOriginPrice as? Int, rank: nikeRank as? Int, src: nikeSrc as? String)
                    for likeShoes in shoesLikeList {
                        if likeShoes.name == nikeGetData.name {
                            nikeGetData.like = true
                        }
                    }
                    shoesGetDataList.append(nikeGetData) // 나이키 데이터를 모든 신발 리스트에 저장
                }
                
                nikeCollectionViewList.removeAll()
                nikeCollectionViewList = self.divideNike(shoes: shoesGetDataList)
                self.shoesCollectionView.reloadData()
            }
        })
    }
    
    func updateNewbalance() {
        refNewbalance = Database.database().reference().child("Newbalance")
        refNewbalance.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount>0 {
                newbalanceCollectionViewList.removeAll()

                for newbalances in snapshot.children.allObjects as! [DataSnapshot] {
                    let newbalanceObject = newbalances.value as? [String: AnyObject]
                    let newbalanceBrand = newbalanceObject?["brand"]
                    let newbalanceDiscountPrice = newbalanceObject?["discountPrice"]
                    let newbalanceImg = newbalanceObject?["img"]
                    let newbalanceLike = newbalanceObject?["like"]
                    let newbalanceName = newbalanceObject?["name"]
                    let newbalanceOriginPrice = newbalanceObject?["originPrice"]
                    let newbalanceRank = newbalanceObject?["rank"]
                    let newbalanceSrc = newbalanceObject?["src"]

                    var newbalanceGetData = Shoes(brand: newbalanceBrand as? String, discountPrice: newbalanceDiscountPrice as? Int, img: newbalanceImg as? String, like: newbalanceLike as? Bool, name: newbalanceName as? String, originPrice: newbalanceOriginPrice as? Int, rank: newbalanceRank as? Int, src: newbalanceSrc as? String)
                    for likeShoes in shoesLikeList {
                        if likeShoes.name == newbalanceGetData.name {
                            newbalanceGetData.like = true
                        }
                    }
                    shoesGetDataList.append(newbalanceGetData)
                }
                newbalanceCollectionViewList.removeAll()
                newbalanceCollectionViewList = self.divideNewbalance(shoes: shoesGetDataList)
                self.shoesCollectionView.reloadData()
            }
        })
    }
    
    func divideNike(shoes:[Shoes]) -> [Shoes] {
        var nikeShoes: [Shoes] = []

        for shoe in shoes {
            if shoe.brand == "Nike" {
                nikeShoes.append(shoe)
            }
        }
        return nikeShoes
    }
    func divideNewbalance(shoes:[Shoes]) -> [Shoes] {
        var newbalanceShoes: [Shoes] = []

        for shoe in shoes {
            if shoe.brand == "Newbalance" {
                newbalanceShoes.append(shoe)
            }
        }
        return newbalanceShoes
    }
}

extension ShoesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "nikeDetailSegue", sender: nikeCollectionViewList[indexPath.row])
        } else {
            performSegue(withIdentifier: "newbalanceDetailSegue", sender: newbalanceCollectionViewList[indexPath.row])
        }
    }
}

extension ShoesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = width * 0.3
        return .init(width: value, height: value) // 셀
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let value = (width * 0.2) * 0.4
        let result = UIEdgeInsets.init(top: 10, left: 50, bottom: 10, right: 50) // 셀들 위치 레이아웃
        return result
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shoesHeadCell", for: indexPath) as! ShoesCollectionReusableView
            if indexPath.section == 1 {
                headerView.headerViewImage.image = UIImage(named: "nikelogo")
                return headerView
            } else if indexPath.section == 2 {
                headerView.headerViewImage.image = UIImage(named: "newbalancelogo")
                return headerView
            } else {
                return headerView
            }
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shoesFooterCell", for: indexPath) as! ShoesCollectionFooterReusableView
            if footSize.recommendSize == 0 {
                footerView.recommendLabel.isHidden = true
                footerView.rightFootWidth.isHidden = true
                footerView.rightFootLength.isHidden = true
                footerView.leftFootWidth.isHidden = true
                footerView.leftFootLength.isHidden = true
                footerView.lengthLabel.isHidden = true
                footerView.widthLabel.isHidden = true
                footerView.rightLabel.isHidden = true
                footerView.leftLabel.isHidden = true
                footerView.leftMeasureButton.layer.cornerRadius = 15.0
                footerView.rightMeasureButton.layer.cornerRadius = 15.0
            } else {
                footerView.firstLabel.isHidden = true
                footerView.firstLabel.isEnabled = false
                footerView.recommendLabel.isHidden = false
                footerView.rightFootWidth.isHidden = false
                footerView.rightFootLength.isHidden = false
                footerView.leftFootLength.isHidden = false
                footerView.leftFootWidth.isHidden = false
                footerView.lengthLabel.isHidden = false
                footerView.widthLabel.isHidden = false
                footerView.rightLabel.isHidden = false
                footerView.leftLabel.isHidden = false
                footerView.recommendLabel.text = "추천 사이즈 : \(footSize.recommendSize ?? 0)"
                footerView.rightFootLength.text = "\(rightFootSize.length ?? 0)"
                footerView.rightFootWidth.text = "\(rightFootSize.width ?? 0)"
                footerView.leftFootLength.text = "\(leftFootSize.length ?? 0)"
                footerView.leftFootWidth.text = "\(leftFootSize.width ?? 0)"
                footerView.leftMeasureButton.isHidden = false
                footerView.rightMeasureButton.isHidden = false
                footerView.leftMeasureButton.layer.cornerRadius = 15.0
                footerView.rightMeasureButton.layer.cornerRadius = 15.0
            }
            
            return footerView
        default:
            assert(false, "Invalid element type")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0  {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section != 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
