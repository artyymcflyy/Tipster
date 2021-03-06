//
//  ViewController.swift
//  Tipster
//
//  Created by Arthur Burgin on 1/28/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TCViewController: UIViewController {

    @IBOutlet var billField: UITextField!
    @IBOutlet var secondView: UIView!
    @IBOutlet var firstView: UIView!
    @IBOutlet var billFieldView: UITextField!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var numPatronLabel: UILabel!
    @IBOutlet var tipControl: UISegmentedControl!
    let tipPercentage = [18, 20, 25]
    let numFormat = NumberFormatter()
    let defaults = UserDefaults.standard
    var myBill:Double!
    var myTip:Double!
    var myTotal:Double!
    var myNumPatron:Double!
    let darkBlue = UIColor(red: 10.0/255.0, green: 80.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    let backgroundBlue = UIColor(red: 32.0/255.0, green: 101.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setNumFormatProperties()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateView()
        
        billField.becomeFirstResponder()
        
        setViewColor()
        
        updateView()
        
    }
    
    //set the color of the view based on toggle value
    func setViewColor(){
        if defaults.bool(forKey: "isDark"){
            self.view.backgroundColor = UIColor.black
            self.firstView.backgroundColor = UIColor.gray
            self.secondView.backgroundColor = UIColor.gray
            self.billFieldView.backgroundColor = UIColor.gray
        }else{
            self.view.backgroundColor = backgroundBlue
            self.firstView.backgroundColor = darkBlue
            self.secondView.backgroundColor = darkBlue
            self.billFieldView.backgroundColor = darkBlue
        }
    }
    
    //animate view when it appears
    func animateView(){
        firstView.alpha = 0
        secondView.alpha = 0
        
        UIView.animate(withDuration: 1.2, animations: {
            self.firstView.alpha = 1
            self.secondView.alpha = 1
        })
    }
    
    //update the view based on persisted data
    func updateView(){
        
        if defaults.bool(forKey: "isReset"){
            resetValues()
            defaults.set(false, forKey: "isReset")
        }else if defaults.object(forKey: "bill") != nil{
            if defaults.double(forKey: "bill") == 0.0{
                billField.text = ""
            }else if billField.text != ""{
                calculateTip(self)
            }else{
                billField.text = String(defaults.double(forKey: "bill"))
                tipLabel.text = defaults.string(forKey: "tip")
                totalLabel.text = defaults.string(forKey: "total")
                tipControl.selectedSegmentIndex = defaults.integer(forKey: "segment")
                numPatronLabel.text = defaults.string(forKey: "numPatron")
            }
            
        }
    }
    
    //calculates the total based on bill and tip amounts
    func calculateTotal(_ val: Int){
        
        myNumPatron = Double(numPatronLabel.text!)
        myBill = Double(billField.text!) ?? 0
        myTip = (myBill * (Double(val)/100))/myNumPatron
        myTotal = myBill/myNumPatron + myTip
        
        tipLabel.text = numFormat.string(from: myTip as NSNumber)!
        totalLabel.text = numFormat.string(from: myTotal as NSNumber)
    }
    
    //init number formatter properites
    func setNumFormatProperties(){
        numFormat.groupingSeparator = ","
        numFormat.numberStyle = .currency
        numFormat.locale = Locale.current
    }
    
    //persists values from each field
    func saveValues(_ aBill: Double, _ aTip: String, _ aTotal: String, _ aNumPatron: Int){
        defaults.set(aBill, forKey: "bill")
        defaults.set(aTip, forKey: "tip")
        defaults.set(aTotal, forKey: "total")
        defaults.set(aNumPatron, forKey: "numPatron")
        defaults.set(tipControl.selectedSegmentIndex, forKey: "segment")
    }
    
    //reset all values except default tip percentage
    func resetValues(){
        defaults.set(false, forKey: "toggle")
        saveValues(0.00, "$0.00", "$0.00", 1)
        calculateTotal(0)
    }
    
    
    //determines whether to calculate tip with the default value or selected segment
    @IBAction func calculateTip(_ sender: AnyObject) {
        if defaults.bool(forKey: "toggle"){
            calculateTotal(defaults.integer(forKey: "slider"))
        }else{
            calculateTotal(tipPercentage[tipControl.selectedSegmentIndex])
        }
        saveValues(myBill, tipLabel.text!, totalLabel.text!, Int(myNumPatron))
        
    }
    
    //subtracts num of patrons to divide by
    @IBAction func subtractPatron(_ sender: Any) {
        var numPatron = Int(numPatronLabel.text!)
        if numPatron! > 1{
            numPatron = numPatron! - 1
            numPatronLabel.text = "\(numPatron!)"
        }
        calculateTip(sender as AnyObject)
        
    }
    
    //adds num of patrons to divide by
    @IBAction func addPatron(_ sender: Any) {
        var numPatronVal = Int(numPatronLabel.text!)
        numPatronVal = numPatronVal! + 1
        numPatronLabel.text = "\(numPatronVal!)"
        calculateTip(sender as AnyObject)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

