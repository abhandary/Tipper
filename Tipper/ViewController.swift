//
//  ViewController.swift
//  Tipper
//
//  Created by Akshay Bhandary on 1/17/17.
//  Copyright © 2017 Akshay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    
    // container views
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var containingView: UIView!
    
    // tip amount and totoal amount labels
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    
    // constraints
    @IBOutlet weak var containerViewVerticalSpaceToTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerViewVeriticalSpaceToBottomConstraint: NSLayoutConstraint!
    
    // division amount labels
    @IBOutlet weak var firstDivisionAmountLabel: UILabel!
    @IBOutlet weak var secondDivisionAmountLabel: UILabel!
    @IBOutlet weak var thirdDivisionAmountLabel: UILabel!
    
    let kDefaultPercentageStringKey = "kDefaultPercentageStringKey"
    
    var topViewOffset = true;
    
    var tipPercentageArray = [0.18, 0.20, 0.25];
    var divisionArray      = [0.5, 0.33, 0.25];
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.bottomView.isHidden = true;

        self.containerViewVerticalSpaceToTopConstraints.constant = 150;
        self.containerViewVeriticalSpaceToBottomConstraint.constant = -150;
        
        setupAmountTextField();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        let defaultPercentage = defaults.integer(forKey: kDefaultPercentageStringKey);
        
        self.tipSegmentedControl.selectedSegmentIndex = defaultPercentage;
    }
    
    func setupAmountTextField() {
        var frameRect = self.amountTextField.frame;
        frameRect.size.height = 50;
        self.amountTextField.frame = frameRect;
        self.amountTextField.becomeFirstResponder();
        
        let borderLayer = CALayer();
        let borderWidth = (2.0 as CGFloat);
        borderLayer.borderColor =  UIColor.darkGray.cgColor;  //[UIColor darkGrayColor].CGColor;
        let rect = CGRect(x: 0, y: self.amountTextField.frame.size.height - borderWidth + 5,
                          width: self.amountTextField.frame.size.width, height: 2.0);
        borderLayer.frame = rect;
        borderLayer.borderWidth = borderWidth;
        self.amountTextField.layer.addSublayer(borderLayer);
        self.amountTextField.layer.masksToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentedControlChanged(_ sender: Any) {
        amountTextFieldDidChange(sender);
    }

    @IBAction func amountTextFieldDidChange(_ sender: Any) {

        
        if topViewOffset {
            topViewOffset = false;
            self.bottomView.isHidden = false;
            
            self.containerViewVerticalSpaceToTopConstraints.constant = 0;
            self.containerViewVeriticalSpaceToBottomConstraint.constant = 0;
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            });
            
            
        }
        
        if self.amountTextField.text!.characters.count == 0 {
            topViewOffset = true;
            self.bottomView.isHidden = true;
            
            self.containerViewVerticalSpaceToTopConstraints.constant = 150;
            self.containerViewVeriticalSpaceToBottomConstraint.constant = -150;
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            });
        }
        
        let amount = Double(self.amountTextField.text!) ?? 0;
        let tipAmount = amount * self.tipPercentageArray[self.tipSegmentedControl.selectedSegmentIndex]
        let totalAmount = amount + tipAmount;
        
        self.tipAmountLabel.text = String(format: "$%.2f", tipAmount);
        self.totalAmountLabel.text = String(format: "$%.2f", totalAmount);
        
        self.firstDivisionAmountLabel.text = String(format: "$%.2f", totalAmount * divisionArray[0]);
        self.secondDivisionAmountLabel.text = String(format: "$%.2f", totalAmount * divisionArray[1]);
        self.thirdDivisionAmountLabel.text = String(format: "$%.2f", totalAmount * divisionArray[2]);
    }

    @IBAction func topViewTapped(_ sender: UITapGestureRecognizer) {
        self.amountTextField.resignFirstResponder()
    }
    
}

