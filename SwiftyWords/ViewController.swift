//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Kenneth Wilcox on 11/17/15.
//  Copyright © 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var cluesLabel: UILabel!
  @IBOutlet weak var answersLabel: UILabel!
  @IBOutlet weak var currentAnswer: UITextField!
  @IBOutlet weak var scoreLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func submitTapped(sender: UIButton) {
    
  }
  
  @IBAction func clearTapped(sender: UIButton) {
    
  }
}

