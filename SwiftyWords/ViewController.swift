//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Kenneth Wilcox on 11/17/15.
//  Copyright © 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
  
  @IBOutlet weak var cluesLabel: UILabel!
  @IBOutlet weak var answersLabel: UILabel!
  @IBOutlet weak var currentAnswer: UITextField!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var letterButtons = [UIButton]()
  var activatedButtons = [UIButton]()
  var solutions = [String]()
  
  var score = 0
  var level = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    for subview in view.subviews where subview.tag == 1001 {
      let btn = subview as! UIButton
      letterButtons.append(btn)
      btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
    }
    
    loadLevel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func submitTapped(sender: UIButton) {
    
  }
  
  @IBAction func clearTapped(sender: UIButton) {
    
  }
  
  func letterTapped(btn: UIButton) {
    currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
    activatedButtons.append(btn)
    btn.hidden = true
  }
  
  func loadLevel() {
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
      if let levelContents = try? String(contentsOfFile: levelFilePath, usedEncoding: nil) {
        var lines = levelContents.componentsSeparatedByString("\n")
        lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String]
        
        for (index, line) in lines.enumerate() {
          let parts = line.componentsSeparatedByString(": ")
          let answer = parts[0]
          let clue = parts[1]
          
          clueString += "\(index + 1). \(clue)\n"
          
          let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
          solutionString += "\(solutionWord.characters.count) letters\n"
          solutions.append(solutionWord)
          
          let bits = answer.componentsSeparatedByString("|")
          letterBits += bits
        }
      }
    }
    
    // Now configure the buttons and labels
    cluesLabel.text = clueString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    answersLabel.text = solutionString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    
    letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
    letterButtons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterButtons) as! [UIButton]
    
    if letterBits.count == letterButtons.count {
      for i in 0 ..< letterBits.count {
        letterButtons[i].setTitle(letterBits[i], forState: .Normal)
      }
    }
  }
}

