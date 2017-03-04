//
//  ViewController.swift
//  Snap Photo
//
//  Created by Yassine on 26/02/2017.
//  Copyright © 2017 Yassine EN. All rights reserved.
//

import UIKit
import BWWalkthrough
import GoogleMobileAds


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BWWalkthroughViewControllerDelegate  {
    var imageFromURL = UIImage()
    var imageLinksData : [String] = []
    var interstitial = GADInterstitial()
    
    @IBOutlet weak var BannerView: GADBannerView!
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAndLoadInterstitial()
        makeAd()
        
        
        let width = self.collectionView.frame.width / 4.1
        let height = width
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
        
        for i in 1...52 {
            imageLinksData.append("IMG_\(i)")
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            HelpButton(Any.self)
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinksData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ImageCollectionViewCell
        
        DispatchQueue.main.async {
            cell.imageCell.image = UIImage(named: self.imageLinksData[indexPath.row])?.resized(withPercentage: 0.4)
            
            
        }
        
        
        
        
        return cell
    }
    
    func showModal() {
        let presentImageViewController = PresentImageViewController()
        presentImageViewController.modalPresentationStyle = .overCurrentContext
        present(presentImageViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.025*3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "identifier" {
            
            if let destinationViewController = segue.destination as? PresentImageViewController, let indexPaths = collectionView?.indexPathsForSelectedItems, let selectedIndexPath = indexPaths.first {
                destinationViewController.LinkData = imageLinksData[selectedIndexPath.item]
                
                ShowAds()
            }
            
        }
    }
    
    func saveImageFromURL(UrlOnIndexPath: String) {
        let url = URL(string: UrlOnIndexPath)
        let data = try? Data(contentsOf: url!)
        imageFromURL = UIImage(data: data!)!
        
    }
    
    @IBAction func HelpButton(_ sender: Any) {
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        //let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        //walkthrough.add(viewController:page_zero)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    //SHOW ADS
    //BANNER
    func makeAd() {
        
        BannerView.adUnitID = "ca-app-pub-1421873277477413/3033330689"
        BannerView.rootViewController = self
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        BannerView.load(request)
        
        
    }
    // INTERSTITIAL
    var CounterAds = 3
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1421873277477413/4510063889")
        let request = GADRequest()
        //TEST CODE
       // request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }
    func ShowAds() {
        if (interstitial.isReady && CounterAds == 3) {
            interstitial.present(fromRootViewController: self)
            CounterAds = 0
            createAndLoadInterstitial()
        }else
        {
            CounterAds += 1
        }
    }
    
    
    
}

