//
//  ViewController.swift
//  portScanner
//
//  Created by Fernando Ortiz Rico Celio on 3/11/18.
//  Copyright © 2018 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import SwiftSocket

var addressGlobal = ""

class ViewController: UIViewController {
    // Outlets
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var startPortTxt: UITextField!
    @IBOutlet weak var stopPortTxt: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // Scans ports from an address and a range given by the user
    func scanPorts(address : String, start : Int, stop : Int) {
        var openPorts : [Int] = []
        
        for port in start...stop {
            let client = TCPClient(address: address, port: Int32(port))
            addressGlobal = address
            
            switch client.connect(timeout: 2) {
            // There's connection
            case .success:
                // Port number is stored in an array
                openPorts.append(port)
            // Can't establish connection
            case .failure(let error):
                print("\(port): \(error.localizedDescription)")
            }
            if port == stop {
                performSegue(withIdentifier: "showTable", sender: nil)
            }
        }
        UserDefaults.standard.set(openPorts, forKey: "ActivePorts")
//        performSegue(withIdentifier: "showTable", sender: nil)
    }
    
    func displayAlert(title : String, msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func scan(_ sender: Any) {
        if let address = addressTxt.text {
            if let start : Int = Int(startPortTxt.text!) {
                if let stop : Int = Int(stopPortTxt.text!) {
                    if start < stop {
                        scanPorts(address: address, start: start, stop: stop)
                    } else {
                        displayAlert(title: "Error en el rango", msg: "Ingresa un rango válido")
                    }
                } else {
                    displayAlert(title: "Campos vacíos", msg: "Ingresa todos los datos necesarios.")
                }
            }else {
                displayAlert(title: "Campos vacíos", msg: "Ingresa todos los datos necesarios.")
            }
        }else {
            displayAlert(title: "Campos vacíos", msg: "Ingresa todos los datos necesarios.")
        }
        
    }
    
    


}

