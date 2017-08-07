//
//  Article.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/2/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit

class Article: NSObject {
    var title: String?
    var author: String?
    var url: String?
    var imageUrl: String?
    var authorImg: UIImage?
    var favorite: Bool
    var saved = 0

    
    init(title: String, url: String, imageUrl: String, favorite: Bool) {
        self.title = title
        self.url = url
        self.imageUrl = imageUrl
        self.favorite = favorite
    }
    
    func setAuthorPic() {
        
    }
    
    func favToggle() {
        if favorite == false {
            favorite = true
        } else {
            favorite = false
        }
    }
    
    func getFavStatus() -> Bool {
        return favorite
    }
    
}
