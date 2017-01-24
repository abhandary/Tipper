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
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var divideByPeopleView: UIView!
    @IBOutlet weak var tipAmountView: UIView!
    @IBOutlet weak var totalAmountView: UIView!
    @IBOutlet weak var totalAmountNestedView: UIView!
    @IBOutlet weak var divideByTwoView: UIView!
    @IBOutlet weak var divideByThreeView: UIView!
    @IBOutlet weak var divideByFourView: UIView!
    
    
    
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
    let kBillAmountKey              = "kBillAmountKey"
    let kCurrentEpochTimeKey        = "kCurrentEpochTimeKey"
    let kThemeStringKey             = "kThemeStringKey"
    
    var topViewOffset = true;
    
    var tipPercentageArray = [0.18, 0.20, 0.25];
    var divisionArray      = [0.5, 0.33, 0.25];
    var billAmount         = 0.0;
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.bottomView.isHidden = true;

        self.containerViewVerticalSpaceToTopConstraints.constant = 150;
        self.containerViewVeriticalSpaceToBottomConstraint.constant = -150;
        
        setupAmountTextField();
        
        setupTheme();
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willResignActive),
                                               name: Notification.Name.UIApplicationWillResignActive, object: nil);
    }
    
    
    func setupTheme() {
        let defaults = UserDefaults()
        let theme = defaults.integer(forKey: kThemeStringKey);
        
        if (theme == 1) {
            let lightColor = UIColor.white;
            self.view.backgroundColor = lightColor
            self.topView.backgroundColor = lightColor
            self.bottomView.backgroundColor = lightColor
            self.containingView.backgroundColor = lightColor
            self.segmentedControlView.backgroundColor = lightColor
            self.divideByPeopleView.backgroundColor = lightColor
            self.totalAmountView.backgroundColor = lightColor
            self.totalAmountNestedView.backgroundColor = lightColor
            self.divideByTwoView.backgroundColor = lightColor
            self.divideByThreeView.backgroundColor = lightColor
            self.divideByFourView.backgroundColor = lightColor
            self.tipAmountView.backgroundColor = lightColor;
            
        } else {
            let darkColor = UIColor(red:0.35, green:0.62, blue:0.76, alpha:1.0);
            self.view.backgroundColor = darkColor
            self.topView.backgroundColor = darkColor
            self.bottomView.backgroundColor = darkColor
            self.containingView.backgroundColor = darkColor
            self.segmentedControlView.backgroundColor = darkColor
            self.divideByPeopleView.backgroundColor = darkColor
            self.totalAmountView.backgroundColor = darkColor
            self.totalAmountNestedView.backgroundColor = darkColor
            self.divideByTwoView.backgroundColor = darkColor
            self.divideByThreeView.backgroundColor = darkColor
            self.divideByFourView.backgroundColor = darkColor
            self.tipAmountView.backgroundColor = darkColor;

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults()
        let defaultPercentage = defaults.integer(forKey: kDefaultPercentageStringKey);
        
        self.tipSegmentedControl.selectedSegmentIndex = defaultPercentage;
        
        setupTheme();
    }
    
    func willResignActive() {
        let defaults = UserDefaults()
        
        defaults.set(self.billAmount, forKey: kBillAmountKey)
        defaults.set(Date().timeIntervalSince1970, forKey: kCurrentEpochTimeKey)
        defaults.synchronize();
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
        
        // setup default amount
        let defaults = UserDefaults()
        let lastEpoch = defaults.double(forKey: kCurrentEpochTimeKey) as TimeInterval;
        
        print(Date().timeIntervalSince(Date(timeIntervalSince1970: lastEpoch)));
        if Date().timeIntervalSince(Date(timeIntervalSince1970: lastEpoch)) < 60 {
            self.amountTextField.text =  "\(defaults.double(forKey: kBillAmountKey))";
            handleBillAmountChange()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentedControlChanged(_ sender: Any) {
        amountTextFieldDidChange(sender);
    }

    @IBAction func amountTextFieldDidChange(_ sender: Any) {
        handleBillAmountChange()
    }
    
    func handleBillAmountChange() {
        
        // A bill amount has been entered, show the tip amount and total amount and
        // divide by people views. Move the bill amount view to the top.
        if topViewOffset {
            topViewOffset = false;
            self.bottomView.isHidden = false;
            
            self.containerViewVerticalSpaceToTopConstraints.constant = 0;
            self.containerViewVeriticalSpaceToBottomConstraint.constant = 0;
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            });
        }
        
        // If a bill amount has not been entered, then offset the top view and hide views like
        // tip amount, total etc which will all be zeroes anyways.
        if self.amountTextField.text!.characters.count == 0 {
            topViewOffset = true;
            self.bottomView.isHidden = true;
            
            self.containerViewVerticalSpaceToTopConstraints.constant = 150;
            self.containerViewVeriticalSpaceToBottomConstraint.constant = -150;
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            });
        }
        
        // calculate tip amount and total amount
        let amount = Double(self.amountTextField.text!) ?? 0;
        self.billAmount = amount;
        let tipAmount = amount * self.tipPercentageArray[self.tipSegmentedControl.selectedSegmentIndex]
        let totalAmount = amount + tipAmount;
        
        // setup number formatter for localized currency
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency;
        formatter.locale = Locale.current;
        
        // set localized tip amount
        var localizedMoneyString = formatter.string(from: NSNumber(value: tipAmount));
        self.tipAmountLabel.text = localizedMoneyString
        
        // set localized total amount
        localizedMoneyString = formatter.string(from: NSNumber(value: totalAmount));
        self.totalAmountLabel.text = localizedMoneyString;
        
        // set localized first division amount
        localizedMoneyString = formatter.string(from: NSNumber(value: totalAmount * divisionArray[0]));
        self.firstDivisionAmountLabel.text = localizedMoneyString
        
        // set localized second division amount
        localizedMoneyString = formatter.string(from: NSNumber(value: totalAmount * divisionArray[1]));
        self.secondDivisionAmountLabel.text = localizedMoneyString
        
        // set localized third division amount
        localizedMoneyString = formatter.string(from: NSNumber(value: totalAmount * divisionArray[2]));
        self.thirdDivisionAmountLabel.text = localizedMoneyString;
    }

    @IBAction func topViewTapped(_ sender: UITapGestureRecognizer) {
        self.amountTextField.resignFirstResponder()
    }
    
    
}

