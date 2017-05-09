//
//  FavoritesViewController.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/3/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].title
        //cell.author.image = self.articles?[indexPath.item].authorImg
        if (self.articles?[indexPath.item].imageUrl != nil) {
            cell.image.loadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
        }
        cell.layer.cornerRadius = 10
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }


}
