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
  
  var score: Int = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  var level = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    for subview in view.subviews where subview.tag == 1001 {
      let btn = subview as! UIButton
      letterButtons.append(btn)
      btn.addTarget(self, action: #selector(ViewController.letterTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    loadLevel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func submitTapped(sender: UIButton) {
    if let solutionPosition = solutions.indexOf(currentAnswer.text!) {
      activatedButtons.removeAll()
      
      var splitClues = answersLabel.text!.componentsSeparatedByString("\n")
      splitClues[solutionPosition] = currentAnswer.text!
      answersLabel.text = splitClues.joinWithSeparator("\n")
      
      currentAnswer.text = ""
      score += 1
      
      if score % 7 == 0 {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
        presentViewController(ac, animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func clearTapped(sender: UIButton) {
    currentAnswer.text = ""
    
    for btn in activatedButtons {
      btn.enabled = true
      btn.alpha = 1.0
    }
    
    activatedButtons.removeAll()
  }
  
  func letterTapped(btn: UIButton) {
    currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
    activatedButtons.append(btn)
    UIView.animateWithDuration(1, delay: 0, options: [], animations: {
      btn.alpha = 0.1
    }) { (finished: Bool) in
      btn.enabled = false
    }
  }
  
  func levelUp(action: UIAlertAction!) {
    level += 1
    if level > 2 {
        level = 1
    }
    
    solutions.removeAll(keepCapacity: true)
    
    loadLevel()
    
    for btn in letterButtons {
      btn.enabled = true
      btn.alpha = 1.0
    }
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

