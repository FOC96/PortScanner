//
//  Terminal.swift
//  portScanner
//
//  Created by Fernando Ortiz Rico Celio on 3/12/18.
//  Copyright © 2018 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import SwiftSocket

class terminal80: UIViewController {
    @IBOutlet weak var consoleText: UITextView!
    @IBOutlet weak var msgText: TextViewDesign!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let consoleTapped = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        consoleTapped.numberOfTapsRequired = 1
        consoleTapped.numberOfTouchesRequired = 1
        consoleText.addGestureRecognizer(consoleTapped)

        NotificationCenter.default.addObserver(self, selector: #selector(terminal80.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(terminal80.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        createCon()
        print("Puerto seleccionado: \(selectedPort)")
    }
    
    
    //Creates the connection and socket to the port NEEDS TO BE FIXED!
    func createCon() {
        let client = TCPClient(address: addressGlobal, port: Int32(selectedPort))
        
        switch client.connect(timeout: 4) {
        case .success:
            consoleText.text = "Connected to \(addressGlobal)"
//            if let response = sendMessage(msg: "GET / HTTP/1.0\n\n", client: client) {
//                showInTextView(string: "Response: \(response)")
//            }
        // Can't establish connection
        case .failure(let error):
            consoleText.text = "💩 Algo salió mal tratando destablecer conexión con \(addressGlobal) \n\(String(describing: error))"
        }
    }
    
    //Moves the view up when keyboard is displayed
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //Moves the view down when keyboard is hiden
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        let client = TCPClient(address: addressGlobal, port: Int32(selectedPort))
        hideKeyboard()
        
        if let msg = msgText.text {
            if msg != "" {
                showInTextView(string: msg)
                msgText.text = ""
                if let response = sendMessage(msg: msg, client: client) {
                    showInTextView(string: "\n\(response)")
                }
            }
        }
        
    }
    
    
    func sendMessage(msg : String, client: TCPClient) -> String? {
        switch client.connect(timeout: 4) {
        case .success:
            switch client.send(string: msg) {
            case .success:
                return readResponse(from: client)
            case .failure(let error):
                showInTextView(string: String(describing: error))
                return nil
            }
        case .failure(let error):
            consoleText.text = "💩 Algo salió mal tratando destablecer conexión con \(addressGlobal) \n\(String(describing: error))"
            return nil
        }
    }
    
    
    
    func showInTextView(string : String) {
        consoleText.text = consoleText.text.appending("\n\(string)")
    }
    
    
    
    func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*90, timeout: 5) else { showInTextView(string: "Error 💩"); return nil }
        let respo = String(bytes: response, encoding: .utf8)
        print(respo)
        return String(bytes: response, encoding: .utf8)
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
