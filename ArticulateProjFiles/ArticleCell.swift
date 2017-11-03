//
//  ArticleCell.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/2/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit
import CoreData

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var author: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var star: UIButton!
    
    var article: Article?
    
    let emptyStar = #imageLiteral(resourceName: "empty star.png")
    let yellowStar = #imageLiteral(resourceName: "yellow star.png")
    
        
   @IBAction func fav(_ sender: Any) {
        article?.favToggle()
        if article?.getFavStatus() == true {
            setYellowStar()
            article?.saveArticle()
            article?.saved = 1
            article?.favorite = true
        } else {
            setEmptyStar()
            article?.unsaveArticle()
            article?.saved = 0
            article?.favorite = false
        }
    }
    
    func setYellowStar() {
        star.setImage(yellowStar, for:UIControlState.normal)
    }
    
    func setEmptyStar() {
        star.setImage(emptyStar, for:UIControlState.normal)
    }
    
    func updateStar() {
        if (article?.getFavStatus() == true) {
            setYellowStar()            
        } else {
            setEmptyStar()
        }
    }
    
}


