//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var selectedCurrency = ""
    var coinManagerObj = CoinManager()
    

    @IBOutlet weak var bitCoinLable: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManagerObj.delegate = self
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

//MARK: - UI PICKER VIEW METHOD AND DELEGATES

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManagerObj.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManagerObj.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCurrency =  coinManagerObj.currencyArray[row]
        
        coinManagerObj.getCoinPrice(for: selectedCurrency)
    }

}

//MARK: - COIN MANAGER DELEGATE

extension ViewController: CoinManagerDelegate {
    
    func didUpdateRate(_ coinmanger: CoinManager, coinData: CoinModel) {
                DispatchQueue.main.async {
                    self.bitCoinLable.text = String(format: "%.1f" ,  coinData.currencyRateInModel)
                    self.currencyLabel.text = self.selectedCurrency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}


