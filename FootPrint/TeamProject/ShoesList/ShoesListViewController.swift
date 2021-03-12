////
////  ShoesListViewController.swift
////  TeamProject
////
////  Created by 홍화형 on 2021/01/13.
////
//
//import UIKit
//import Firebase
//
//class ShoesListViewController: UIViewController {
//
//    var refNike: DatabaseReference!
//    var refNewbalance: DatabaseReference!
//    var nikeList = [Nike]()
//    var newbalanceList = [Newbalance]()
//
//    let width = UIScreen.main.bounds.width
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateNike()
//        updateNewbalance()
//
//        // Do any additional setup after loading the view.
//        shoesCollectionView.delegate = self
//        shoesCollectionView.dataSource = self
//
//        shoesCollectionView.contentInsetAdjustmentBehavior = .never
//        //shoesCollectionView.backgroundColor = .black
//        self.shoesCollectionView.reloadData()
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "shoesDetail" {
//            let VC = segue.destination as! ShoesDetailViewController
//            VC.shoesDetail = sender as? Nike
//        }
//    }
//
//}
//
//extension ShoesListViewController: UICollectionViewDataSource {
////    func numberOfSections(in collectionView: UICollectionView) -> Int {
////        return 2
////    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return nikeList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoesCell", for: indexPath) as! ShoesCollectionViewCell
//        //cell.shoesImageView.image = nikeList[indexPath.row].img
//        //cell.shoesImageView.layer.cornerRadius = 20.0
//        let nike:Nike
//        nike = nikeList[indexPath.row]
//        cell.shoesLabel.text = nike.name
//        cell.backgroundColor = .red
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shoesHeadCell", for: indexPath)
//            return headerView
//        default:
//            assert(false, "Invalid element type")
//        }
//    }
//
//    func updateNike() {
//        refNike = Database.database().reference().child("Nike")
//        refNike.observe(DataEventType.value, with: {(snapshot) in
//            if snapshot.childrenCount>0 {
//                self.nikeList.removeAll()
//
//                for nikes in snapshot.children.allObjects as! [DataSnapshot] {
//                    let nikeObject = nikes.value as? [String: AnyObject]
//                    let nikeBrand = nikeObject?["brand"]
//                    let nikeDiscountPrice = nikeObject?["discountPrice"]
//                    let nikeImg = nikeObject?["img"]
//                    let nikeLike = nikeObject?["like"]
//                    let nikeName = nikeObject?["name"]
//                    let nikeOriginPrice = nikeObject?["originPrice"]
//                    let nikeRank = nikeObject?["rank"]
//                    let nikeSrc = nikeObject?["src"]
//
//                    let nike = Nike(brand: nikeBrand as? String, discountPrice: nikeDiscountPrice as? Int, img: nikeImg as! String, like: nikeLike as? Bool, name: nikeName as! String, originPrice: nikeOriginPrice as? Int, rank: nikeRank as? Int, src: nikeSrc as? String)
//                    self.nikeList.append(nike)
//                    print(nike.name!)
//                }
//                //self.shoesCollectionView.reloadData()
//            }
//        })
//    }
//
//    func updateNewbalance() {
//        refNewbalance = Database.database().reference().child("Newbalance")
//        refNewbalance.observe(DataEventType.value, with: {(snapshot) in
//            if snapshot.childrenCount>0 {
//                self.newbalanceList.removeAll()
//
//                for newbalances in snapshot.children.allObjects as! [DataSnapshot] {
//                    let newbalanceObject = newbalances.value as? [String: AnyObject]
//                    let newbalanceBrand = newbalanceObject?["brand"]
//                    let newbalanceDiscountPrice = newbalanceObject?["discountPrice"]
//                    let newbalanceImg = newbalanceObject?["img"]
//                    let newbalanceLike = newbalanceObject?["like"]
//                    let newbalanceName = newbalanceObject?["name"]
//                    let newbalanceOriginPrice = newbalanceObject?["originPrice"]
//                    let newbalanceRank = newbalanceObject?["rank"]
//                    let newbalanceSrc = newbalanceObject?["src"]
//
//                    let newbalance = Newbalance(brand: newbalanceBrand as? String, discountPrice: newbalanceDiscountPrice as? Int, img: newbalanceImg as! String, like: newbalanceLike as? Bool, name: newbalanceName as! String, originPrice: newbalanceOriginPrice as? Int, rank: newbalanceRank as? Int, src: newbalanceSrc as? String)
//                    self.newbalanceList.append(newbalance)
//                }
//                //self.shoesCollectionView.reloadData()
//            }
//        })
//    }
//
//}
//
//extension ShoesListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let value = width * 0.4
//        return .init(width: value, height: value) // 셀
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let value = (width * 0.2) * 0.4
//        return .init(top: 10, left: value, bottom: 10, right: value) // 셀들 위치 레이아웃
//    }
//}
//
//extension ShoesListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "shoesDetail", sender: self.nikeList[indexPath.row])
//    }
//}
//
//
//
////    var shoesList: [shoes] = [shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "airforce1")!, shoesName: "airforce1", price: 109_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "airmax97")!, shoesName: "airmax97", price: 199_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "airmonarch")!, shoesName: "airmonarch", price: 79_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "dunklow")!, shoesName: "dunklow", price: 119_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "jordan1")!, shoesName: "jordan1", price: 119_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "killshot2")!, shoesName: "killshot2", price: 99_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "moonracer")!, shoesName: "moonracer", price: 189_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "airmax95")!, shoesName: "airmax95", price: 179_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "tailwind")!, shoesName: "tailwind", price: 109_000),
////                               shoes(shoesBrand: "Nike", shoesImage: UIImage(named: "daybreak")!, shoesName: "daybreak", price: 129_000)]
