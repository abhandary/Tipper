//
//  SettingsViewController.swift
//  Tipper
//
//  Created by Akshay Bhandary on 1/17/17.
//  Copyright © 2017 Akshay. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var tipPercentageSegmentedControl: UISegmentedControl!
    let kDefaultPercentageStringKey = "kDefaultPercentageStringKey"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let defaults = UserDefaults()
        let defaultPercentage = defaults.integer(forKey: kDefaultPercentageStringKey);
        
        self.tipPercentageSegmentedControl.selectedSegmentIndex = defaultPercentage;
    }
    
    @IBAction func tipPercentageSegmentedControlValueChanged(_ sender: Any) {
        let defaults = UserDefaults()
        defaults.set(self.tipPercentageSegmentedControl.selectedSegmentIndex, forKey: kDefaultPercentageStringKey);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
