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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        askForAuth()
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
        shell?.withCallback { (string: String?, error: String?) in
            print("\(string ?? error!)")
            }
        
        shell?.connect({ (error) in
            print(String(describing: error))
        })
        shell?.authenticate(.byPassword(username: user, password: pass))
        shell?.open({ (error) in
            if (self.shell?.authenticated)! {
                self.showInTextView(string: "Opening the channel...")
                self.showInTextView(string: "Opening the shell...")
                self.showInTextView(string: "Shell opened successfully 🎉")
            }
        })

        var res = self.shell?.authenticated as! Bool
        
        print(res)
        
        if res {
            print("SUCCESS")
        } else {
            self.askForAuth()
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
