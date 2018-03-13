//
//  Terminal.swift
//  portScanner
//
//  Created by Fernando Ortiz Rico Celio on 3/12/18.
//  Copyright © 2018 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import SwiftSocket

class Terminal: UIViewController {
    @IBOutlet weak var consoleText: UITextView!
    @IBOutlet weak var msgText: TextViewDesign!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let consoleTapped = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        consoleTapped.numberOfTapsRequired = 1
        consoleTapped.numberOfTouchesRequired = 1
        consoleText.addGestureRecognizer(consoleTapped)

        NotificationCenter.default.addObserver(self, selector: #selector(Terminal.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Terminal.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        print(selectedPort)
        createCon()
    }
    
    
    //Creates the connection and socket to the port NEEDS TO BE FIXED!
    func createCon() {
        let client = TCPClient(address: addressGlobal, port: Int32(selectedPort))
        
        switch client.connect(timeout: 4) {
        case .success:
            switch client.send(string: "GET \(addressGlobal) HTTP/1.0\n\n" ) {
            case .success:
                consoleText.text = "CONNECTED TO PORT \(selectedPort)\n\n"
                guard let data = client.read(1024*10) else { return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    var text = consoleText.text
                    text?.append("\n\n\(response)")
                    consoleText.text = text
                }
            case .failure(let error):
                print(error)
            }
        // Can't establish connection
        case .failure(let error):
            consoleText.text = "COULDN'T CONNECT TO PORT \(selectedPort)\n\(error.localizedDescription)"
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
        hideKeyboard()
        if let msg = msgText.text {
            if msg != "" {
                var complete = consoleText.text
                complete?.append("\n\(msg)")
                consoleText.text = complete
                msgText.text = ""
            }
        }
        
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
