//
//  Analytics.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 4/30/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import Foundation

class Analytics {
    private var text = ""
    var likeCount = 0
    var wordCount = 0.0
    
    init (text: String){
        self.text = text
    }
    
    func parseText() {
        var count = 0
        var likes = 0
        let textArray = self.text.characters.split(separator: " ")
        print("show me the data")
        for word in textArray {
            count += 1
            if (String(word) == "like" || String(word) == "Like") {
                likes += 1
            }
        self.wordCount = Double(count)
        self.likeCount = likes
        }
    }
    func getWordCount() -> Double {
        return self.wordCount
    }
    
    func getLikeCount() -> Int {
        return self.likeCount
    }
    func wordsPerSecond() -> Double {
        print(Double(self.wordCount/60))
        return Double(self.wordCount/60)
    }
    
}
