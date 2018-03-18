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
    
    
    // Get number of threads for scan ports
    func getSegmentsQueues(min: Int, max: Int, maxPerSegment: Int) -> [[Int]] {
        
        var start: Int = min
        var portSegments = [[Int]]()
        
        while start <= max {
            var _portSegment = [Int]()
            
            for _ in 1...maxPerSegment {
                
                if start <= max {
                    _portSegment.append(start)
                }
                
                start += 1
            }
            
            portSegments.append(_portSegment)
        }
        
        return portSegments
    }


    // Crate queques for scan ports by segments
    func QueueDispatchPort(address: String, minPort: Int, maxPort: Int, segmentsQueues: (Int, Int, Int) -> [[Int]]) -> [Int] {
        var openPorts : [Int] = []
        let segmentPorts = segmentsQueues(minPort, maxPort, 1);
        
        let group = DispatchGroup()
        
        for segment in segmentPorts {
            group.enter()
            DispatchQueue.global().async {
                
                for port in segment {
                    let client = TCPClient(address: address, port: Int32(port))
                    switch client.connect(timeout: 2) {
                        case .success:
                            openPorts.append(port)
                        case .failure(_):
                            print("port \(port) closed")
                    }
                    
                    client.close()
                }
                group.leave()
            }
        }
        
        group.wait()

        return openPorts
    }
    
    // Scans ports from an address and a range given by the user
    func scanPorts(address : String, start : Int, stop : Int) {
        
        addressGlobal = address
        
        let openPorts = QueueDispatchPort(
            address: address, minPort: start, maxPort: stop, segmentsQueues:
            getSegmentsQueues(min:max:maxPerSegment:))
        
        
        performSegue(withIdentifier: "showTable", sender: nil)
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

