//
//  ViewController.swift
//  TipCalculator
//
//  Created by Tomonao Hashiguchi on 2022-05-10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var billAmountTextField: UITextField!
    @IBOutlet var tipAmountLabel: UILabel!
    @IBOutlet var popupButtonForCustomTip: UIButton!
    @IBOutlet var tipCustomTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var persentageLabelForSlider: UILabel!
    
    var customTipsWithDoller = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup(){
        billAmountTextField.keyboardType = .numberPad
        tipCustomTextField.keyboardType = .numberPad
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        scrollView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        
        setUpPopupButton()
        regiserForKeyboardNotifications()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setUpPopupButton(){
        let optionClosure = {(action: UIAction) in
            if action.title == "$"{
                self.customTipsWithDoller = true
            }else{
                self.customTipsWithDoller = false
            }
        }
        popupButtonForCustomTip.menu = UIMenu(children: [
            UIAction(title: "$", state: .on, handler: optionClosure),
            UIAction(title: "%", handler: optionClosure)
        ])
    }
        
    func regiserForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisapper), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification){
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
    }
    
    @objc func keyboardWillDisapper(){
        scrollView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
    }

    @IBAction func calculateTip(_ sender: UIButton) {
        guard let billAmountDouble = Double(billAmountTextField.text!) else {return}
        let tipRate: Double = Double(sender.restorationIdentifier!)! / 100
        let totalWithTips = billAmountDouble * (1 + tipRate)
        tipAmountLabel.text = "$\(String(format: "%.2f", totalWithTips))"
    }
    
    @IBAction func calculateTipForCustom() {
        guard let billAmountDouble = Double(billAmountTextField.text!) else {return}
        guard let tip = Double(tipCustomTextField.text!) else {return}
        if customTipsWithDoller {
            let totalWithTips = billAmountDouble + tip
            tipAmountLabel.text = "$\(String(format: "%.2f", totalWithTips))"
        }else{
            let totalWithTips = billAmountDouble * (1 + tip / 100)
            tipAmountLabel.text = "$\(String(format: "%.2f", totalWithTips))"
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let persentage = String(format: "%.0f", sender.value)
        persentageLabelForSlider.text = "\(persentage)%"
        guard let billAmountDouble = Double(billAmountTextField.text!) else {return}
        let totalWithTips = billAmountDouble * (1 + Double(persentage)! / 100)
        tipAmountLabel.text = "$\(String(format: "%.2f", totalWithTips))"
    }
}

