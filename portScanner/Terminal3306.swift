//
//  Terminal3306.swift
//  portScanner
//
//  Created by Fernando Ortiz Rico Celio on 3/21/18.
//  Copyright © 2018 Fernando Ortiz Rico Celio. All rights reserved.
//

import UIKit
import OHMySQL

class Terminal3306: UIViewController {
    //Elementos
    @IBOutlet weak var consoleText: UITextView!
    @IBOutlet weak var mensajeText: TextViewDesign!

    var userDatabase : OHMySQLUser!
    var coordinator : OHMySQLStoreCoordinator!
    var context : OHMySQLQueryContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.authenticateMySQL()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(Terminal3306.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Terminal3306.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Moves the view up when keyboard is displayed
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    //Moves the view down when keyboard is hiden
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }


    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    func showInTextView(string : String) {
        consoleText.text = consoleText.text.appending("\n\(string)")
    }


    func authenticateMySQL() {
        let alert = UIAlertController(title: "Iniciar sesión", message: "Ingresa tus datos de sesión para usar con MYSQL", preferredStyle: .alert)

        alert.addTextField { (textfieldUser) in
            textfieldUser.placeholder = "Usuario"
        }

        alert.addTextField { (textfieldPass) in
            textfieldPass.placeholder = "Contraseña"
            textfieldPass.isSecureTextEntry = true
        }

        alert.addTextField { (textfieldDatabase) in
            textfieldDatabase.placeholder = "Base de datos"
        }

        let signIn = UIAlertAction(title: "Ingresar", style: .default) { (action) in
            print("Iniciando")
            let user = alert.textFields![0]
            let password = alert.textFields![1]
            let database = alert.textFields![2]
        

            print(user.text!)
            print(password.text!)
            print(database.text!)
            

            self.userDatabase = self.createUserDatabase(username: user.text!, password: password.text!,
                    serverName: addressGlobal, database: database.text!, port: 3306)
            
            self.coordinator = OHMySQLStoreCoordinator(user: self.userDatabase)
            self.coordinator.encoding = .UTF8
            self.coordinator.connect()
            
            self.context = OHMySQLQueryContext()
            self.context.storeCoordinator = self.coordinator
            
            self.showInTextView(string: "successfully connected")
        }

        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }

        alert.addAction(signIn)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    // Create user for store
    func createUserDatabase(username: String, password: String, serverName: String, database: String, port: UInt)
                    -> OHMySQLUser {
        return OHMySQLUser(userName: username, password: password,
                serverName: serverName, dbName: database, port: port, socket: nil)!;
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }


    @IBAction func enviarMensaje(_ sender: Any) {
        //let user = OHMySQLUser(userName: "root", password: "", serverName: "localhost", dbName: "saluduaq", port: 3306, socket: nil)
        //let coordinator = OHMySQLStoreCoordinator(user: user!)
        //coordinator.encoding = .UTF8
        //coordinator.connect()
        //let context = OHMySQLQueryContext()
        //context.storeCoordinator = coordinator
        consoleText.text = ""

        let query = OHMySQLQueryRequest(queryString: mensajeText.text)
        showInTextView(string: query.queryString)

        let response = try? self.context.executeQueryRequestAndFetchResult(query)
    
        showInTextView(string: json(from: response!)!)
        
        mensajeText.text = ""
    }


}
