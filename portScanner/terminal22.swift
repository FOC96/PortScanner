//
//  terminal22.swift
//  portScanner
//
//  Created by Fernando Ortiz Rico Celio on 3/18/18.
//  Copyright © 2018 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import SwiftSH

class terminal22: UIViewController {
    
    @IBOutlet weak var consoleText: UITextView!
    let shell = Shell(host: addressGlobal, port: 22)
    @IBOutlet weak var commandText: TextViewDesign!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(terminal22.moveKeyboardUp), name: NSNotification.Name, object: nil)
        
        shell?.connect({ (error) in
            if (self.shell?.connected)! {
                self.askForAuth()
            } else {
                self.showInTextView(string: "💩 \(String(describing: error))")
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func askForAuth() {
        let alert = UIAlertController(title: "Iniciar sesión", message: "Ingresa tus datos de sesión para usar SSH", preferredStyle: .alert)
        alert.addTextField { (textfieldUser) in
            textfieldUser.placeholder = "Usuario"
        }
        alert.addTextField { (textfieldPass) in
            textfieldPass.placeholder = "Contraseña"
            textfieldPass.isSecureTextEntry = true
        }
        let signIn = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            print("Iniciando")
            let user = alert.textFields![0]
            let password = alert.textFields![1]
            
            self.checkCredentials(user: user.text!, pass: password.text!)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(signIn)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func checkCredentials(user: String, pass: String) {
        self.shell?.authenticate(AuthenticationChallenge.byPassword(username: user, password: pass), completion: { (newError) in
            if (self.shell?.authenticated)! {
                self.shell?.open({ (openError) in
                    if openError == nil {
                        self.showInTextView(string: "Opening the channel...")
                        self.showInTextView(string: "Opening the shell...")
                        self.showInTextView(string: "Shell opened successfully 🎉")
                    } else {
                        self.showInTextView(string: "💩 OPEN SHELL \(String(describing: openError))")
                    }
                })
            } else {
                self.showInTextView(string: "💩 AUTH \(String(describing: newError))")
                self.askForAuth()
            }
        })
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        hideKeyboard()
        if let command = commandText.text, command != "" {
            shell?.write("\(command)\n", completion: { (error) in
                if let error = error {
                    self.showInTextView(string: String(describing: error))
                } else {
                    self.showInTextView(string: command)
                }
            })
        }
        
        commandText.text = ""
    }
    
    
    
    
    
    func showInTextView(string : String) {
        consoleText.text = consoleText.text.appending("\n\(string)")
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (shell?.connected)! {
            if (shell?.authenticated)! {
                shell?.disconnect(nil)
                showInTextView(string: "Bye bye")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (shell?.connected)! {
            if (shell?.authenticated)! {
                shell?.disconnect(nil)
                showInTextView(string: "Bye bye")
            }
        }
    }
    
    func moveKeyboardUp() {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
    }
    
    
    func hideKeyboard() {
        self.view.endEditing(true)
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
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
