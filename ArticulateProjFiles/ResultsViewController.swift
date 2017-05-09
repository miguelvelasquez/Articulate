//
//  ResultsViewController.swift
//  Articulate
//
//  Created by Miguel A Velasquez on 5/3/17.
//  Copyright © 2017 Miguel A Velasquez. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var wordCountView: UILabel!
    @IBOutlet weak var speedView: UILabel!
    @IBOutlet weak var likeCountView: UILabel!
    
    var wordCount = 0.0
    var wps = 0.0
    var likeCount = 0
    
    
    var results: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayValues()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func computeResults() {
        if (self.results != nil) {
            let data = Analytics(text: self.results!)
            data.parseText()
            self.wordCount = data.getWordCount()
            self.wps = round(100*data.wordsPerSecond())/100
            self.likeCount = data.getLikeCount()
        }
    }
    
    func displayValues() {
        wordCountView.text = "You said a total of " + String(self.wordCount) + " words"
        speedView.text = "You spoke at a speed of " + String(self.wps) + " words per second"
        likeCountView.text = "You said 'Like' a total of " + String(self.likeCount) + " times"
    }
    
    @IBAction func Xout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
