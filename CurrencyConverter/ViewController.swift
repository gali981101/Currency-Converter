//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Terry Jason on 2023/8/6.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var twdLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var krwLabel: UILabel!
    @IBOutlet weak var hkdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getRatesClicked(_ sender: Any) {
        startLoad()
    }
    
}

extension ViewController {
    
    func startLoad() {
        
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=103f4a0871d9aa4f7bbd9eecdd6307bc")
        
        let task = URLSession.shared.dataTask(with: url!) { [self] data, response, error in
            if error != nil {
                errorAlert(error: error)
            } else {
                fetchData(data: data)
            }
        }
        
        task.resume()
        
    }
    
}

extension ViewController {
    
    private func errorAlert(error: Error?) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
    
    private func fetchData(data: Data?)  {
        if data != nil {
            do {
                let jsonResponse =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                processData(dictionary: jsonResponse)
            } catch {
                print("error")
            }
        }
    }
 
    private func processData(dictionary: Dictionary<String, Any>) {
        DispatchQueue.main.async { [self] in
            if let rates = dictionary["rates"] as? [String : Double] {
                layOutData(rates: rates)
            }
        }
    }
    
    private func layOutData(rates: [String : Double]) {
        eurRate(rates: rates)
        hkdRate(rates: rates)
        jpyRate(rates: rates)
        krwRate(rates: rates)
        twdRate(rates: rates)
        usdRate(rates: rates)
    }
    
    private func eurRate(rates: [String : Double])  {
        if let eur = rates["EUR"] {
            self.eurLabel.text = "EUR: \(String(eur))"
        }
    }
    
    private func hkdRate(rates: [String : Double]) {
        if let hkd = rates["HKD"] {
            self.hkdLabel.text = "HKD: \(String(hkd))"
        }
    }
    
    private func jpyRate(rates: [String : Double]) {
        if let jpy = rates["JPY"] {
            self.jpyLabel.text = "JPY: \(String(jpy))"
        }
    }
    
    private func krwRate(rates: [String : Double]) {
        if let krw = rates["KRW"] {
            self.krwLabel.text = "KRW: \(String(krw))"
        }
    }
    
    private func twdRate(rates: [String : Double]) {
        if let twd = rates["TWD"] {
            self.twdLabel.text = "TWD: \(String(twd))"
        }
    }
    
    private func usdRate(rates: [String : Double]) {
        if let usd = rates["USD"] {
            self.usdLabel.text = "USD: \(String(usd))"
        }
    }
    
}
